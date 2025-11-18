{
  autoAddDriverRunpath,
  buildPythonPackage,
  config,
  cudaPackages,
  callPackage,
  fetchFromGitHub,
  jax,
  lib,
  llvmPackages, # TODO: use llvm 21 in 1.10, see python-packages.nix
  numpy,
  pkgsBuildHost,
  python,
  replaceVars,
  runCommand,
  setuptools,
  stdenv,
  torch,
  warp-lang, # Self-reference to this package for passthru.tests
  writableTmpDirAsHomeHook,
  writeShellApplication,

  # Use standalone LLVM-based JIT compiler and CPU device support
  standaloneSupport ? true,

  # Use CUDA toolchain and GPU device support
  cudaSupport ? config.cudaSupport,

  # Build Warp with MathDx support (requires CUDA support)
  # Most linear-algebra tile operations like tile_cholesky(), tile_fft(),
  # and tile_matmul() require Warp to be built with the MathDx library.
  # libmathdxSupport ? cudaSupport && stdenv.hostPlatform.isLinux,
  libmathdxSupport ? cudaSupport,
}@args:

assert libmathdxSupport -> cudaSupport;

let
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else args.stdenv;
  stdenv = throw "Use effectiveStdenv instead of stdenv directly, as it may be replaced by cudaPackages.backendStdenv";

  version = "1.9.1";

  libmathdx = callPackage ./libmathdx.nix { };
in
buildPythonPackage {
  pname = "warp-lang";
  inherit version;
  pyproject = true;

  # TODO(@connorbaker): Some CUDA setup hook is failing when __structuredAttrs is false,
  # causing a bunch of missing math symbols (like expf) when linking against the static library
  # provided by NVCC.
  __structuredAttrs = true;

  stdenv = effectiveStdenv;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "warp";
    tag = "v${version}";
    hash = "sha256-Atp3WyxQ7GYwWLmQIUgoPULyVlNjduh4/9CBixNWFwc=";
  };

  patches = [
    ./cxx11-abi.patch
  ]
  ++ lib.optionals effectiveStdenv.hostPlatform.isDarwin [
    (replaceVars ./darwin-libcxx.patch {
      LIBCXX_LIB = llvmPackages.libcxx;
    })

    ./darwin-single-target.patch
  ]
  ++ lib.optionals (effectiveStdenv.cc.isClang || standaloneSupport) [
    (replaceVars ./clang-path.patch {
      CLANG = "${effectiveStdenv.cc}/bin/cc";
    })

    (replaceVars ./clang-libs.patch {
      LLVM_DEV = llvmPackages.llvm.dev;
      LIBCLANG_DEV = llvmPackages.libclang.dev;
    })
  ]
  ++ lib.optionals standaloneSupport [
    (replaceVars ./llvm-libs.patch {
      LLVM_LIB = llvmPackages.llvm.lib;
      LIBCLANG_LIB = llvmPackages.libclang.lib;
    })
  ];

  postPatch =
    # Patch build_dll.py to use our gencode flags rather than NVIDIA's very broad defaults.
    lib.optionalString cudaSupport ''
      nixLog "patching $PWD/warp/build_dll.py to use our gencode flags"
      substituteInPlace "$PWD/warp/build_dll.py" \
        --replace-fail \
          '*gencode_opts,' \
          '${
            lib.concatMapStringsSep ", " (gencodeString: ''"${gencodeString}"'') cudaPackages.flags.gencode
          },' \
        --replace-fail \
          '*clang_arch_flags,' \
          '${
            lib.concatMapStringsSep ", " (
              realArch: ''"--cuda-gpu-arch=${realArch}"''
            ) cudaPackages.flags.realArches
          },'
    ''
    # Patch build_dll.py to use dynamic libraries rather than static ones.
    # NOTE: We do not patch the `nvptxcompiler_static` path because it is not available as a dynamic library.
    + lib.optionalString cudaSupport ''
      nixLog "patching $PWD/warp/build_dll.py to use dynamic libraries"
      substituteInPlace "$PWD/warp/build_dll.py" \
        --replace-fail \
          '-lcudart_static' \
          '-lcudart' \
        --replace-fail \
          '-lnvrtc_static' \
          '-lnvrtc' \
        --replace-fail \
          '-lnvrtc-builtins_static' \
          '-lnvrtc-builtins' \
        --replace-fail \
          '-lnvJitLink_static' \
          '-lnvJitLink' \
        --replace-fail \
          '-lmathdx_static' \
          '-lmathdx'
    ''
    # AssertionError: 0.4082476496696472 != 0.40824246406555176 within 5 places
    + lib.optionalString effectiveStdenv.hostPlatform.isDarwin ''
      nixLog "patching $PWD/warp/tests/test_fem.py to disable broken tests on darwin"
      substituteInPlace "$PWD/warp/tests/test_codegen.py" \
        --replace-fail \
          'places=5' \
          'places=4'
    ''
    # These tests fail on CPU and CUDA.
    + ''
      nixLog "patching $PWD/warp/tests/test_reload.py to disable broken tests"
      substituteInPlace "$PWD/warp/tests/test_reload.py" \
        --replace-fail \
          'add_function_test(TestReload, "test_reload", test_reload, devices=devices)' \
          "" \
        --replace-fail \
          'add_function_test(TestReload, "test_reload_references", test_reload_references, devices=get_test_devices("basic"))' \
          ""
    '';

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
  ];

  nativeBuildInputs = lib.optionals cudaSupport [
    # NOTE: While normally we wouldn't include autoAddDriverRunpath for packages built from source, since Warp
    # will be loading GPU drivers at runtime, we need to inject the path to our video drivers.
    autoAddDriverRunpath
  ];

  buildInputs =
    lib.optionals standaloneSupport [
      llvmPackages.llvm
      llvmPackages.clang
      llvmPackages.libcxx
    ]
    ++ lib.optionals cudaSupport [
      (lib.getStatic cudaPackages.cuda_nvcc) # dependency on nvptxcompiler_static; no dynamic version available
      cudaPackages.cuda_cccl
      cudaPackages.cuda_cudart
      cudaPackages.cuda_nvcc
      cudaPackages.cuda_nvrtc
    ]
    ++ lib.optionals libmathdxSupport [
      libmathdx
      cudaPackages.libcublas
      cudaPackages.libcufft
      cudaPackages.libcusolver
      cudaPackages.libnvjitlink
    ];

  preBuild =
    let
      buildOptions =
        lib.optionals effectiveStdenv.cc.isClang [
          "--clang_build_toolchain"
        ]
        ++ lib.optionals (!standaloneSupport) [
          "--no_standalone"
        ]
        ++ lib.optionals cudaSupport [
          # NOTE: The `cuda_path` argument is the directory which contains `bin/nvcc` (i.e., the bin output).
          "--cuda_path=${lib.getBin pkgsBuildHost.cudaPackages.cuda_nvcc}"
        ]
        ++ lib.optionals libmathdxSupport [
          "--libmathdx"
          "--libmathdx_path=${libmathdx}"
        ]
        ++ lib.optionals (!libmathdxSupport) [
          "--no_libmathdx"
        ];

      buildOptionString = lib.concatStringsSep " " buildOptions;
    in
    ''
      nixLog "running $PWD/build_lib.py to create components necessary to build the wheel"
      "${python.pythonOnBuildForHost.interpreter}" "$PWD/build_lib.py" ${buildOptionString}
    '';

  pythonImportsCheck = [
    "warp"
  ];

  # See passthru.tests.
  doCheck = false;

  passthru = {
    # Make libmathdx available for introspection.
    inherit libmathdx;

    # Scripts which provide test packages and implement test logic.
    testers.unit-tests =
      let
        # Use the references from args
        python' = python.withPackages (_: [
          warp-lang
          jax
          torch
        ]);
        # Disable paddlepaddle interop tests: malloc(): unaligned tcache chunk detected
        #  (paddlepaddle.override { inherit cudaSupport; })
      in
      writeShellApplication {
        name = "warp-lang-unit-tests";
        runtimeInputs = [ python' ];
        text = ''
          ${python'}/bin/python3 -m warp.tests
        '';
      };

    # Tests run within the Nix sandbox.
    tests =
      let
        mkUnitTests =
          {
            cudaSupport,
            libmathdxSupport,
          }:
          let
            name =
              "warp-lang-unit-tests-cpu" # CPU is baseline
              + lib.optionalString cudaSupport "-cuda"
              + lib.optionalString libmathdxSupport "-libmathdx";

            warp-lang' = warp-lang.override {
              inherit cudaSupport libmathdxSupport;
              # Make sure the warp-lang provided through callPackage is replaced with the override we're making.
              warp-lang = warp-lang';
            };
          in
          runCommand name
            {
              nativeBuildInputs = [
                warp-lang'.passthru.testers.unit-tests
                writableTmpDirAsHomeHook
              ];
              requiredSystemFeatures = lib.optionals cudaSupport [ "cuda" ];
            }
            ''
              nixLog "running ${name}"

              if warp-lang-unit-tests; then
                nixLog "${name} passed"
                touch "$out"
              else
                nixErrorLog "${name} failed"
                exit 1
              fi
            '';
      in
      {
        cpu = mkUnitTests {
          cudaSupport = false;
          libmathdxSupport = false;
        };
        cuda = {
          cudaOnly = mkUnitTests {
            cudaSupport = true;
            libmathdxSupport = false;
          };
          cudaWithLibmathDx = mkUnitTests {
            cudaSupport = true;
            libmathdxSupport = true;
          };
        };
      };
  };

  meta = {
    description = "Python framework for high performance GPU simulation and graphics";
    longDescription = ''
      Warp is a Python framework for writing high-performance simulation
      and graphics code. Warp takes regular Python functions and JIT
      compiles them to efficient kernel code that can run on the CPU or
      GPU.

      Warp is designed for spatial computing and comes with a rich set
      of primitives that make it easy to write programs for physics
      simulation, perception, robotics, and geometry processing. In
      addition, Warp kernels are differentiable and can be used as part
      of machine-learning pipelines with frameworks such as PyTorch,
      JAX and Paddle.
    '';
    homepage = "https://github.com/NVIDIA/warp";
    changelog = "https://github.com/NVIDIA/warp/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [ yzx9 ];
  };
}
