{
  autoAddDriverRunpath,
  buildPythonPackage,
  config,
  cudaPackages,
  fetchFromGitHub,
  fetchurl,
  jax,
  lib,
  llvmPackages,
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
  stdenv = builtins.throw "Use effectiveStdenv instead of stdenv directly, as it may be replaced by cudaPackages.backendStdenv";

  version = "1.8.0";

  libmathdx = effectiveStdenv.mkDerivation (finalAttrs: {
    # NOTE: The version used should match the version Warp requires:
    # https://github.com/NVIDIA/warp/blob/${version}/deps/libmathdx-deps.packman.xml
    pname = "libmathdx";
    version = "0.2.1";

    outputs = [
      "out"
      "static"
    ];

    src =
      let
        baseURL = "https://developer.download.nvidia.com/compute/cublasdx/redist/cublasdx";
        name = lib.concatStringsSep "-" [
          finalAttrs.pname
          "Linux"
          effectiveStdenv.hostPlatform.parsed.cpu.name
          finalAttrs.version
        ];

        # nix-hash --type sha256 --to-sri $(nix-prefetch-url "https://...")
        hashes = {
          aarch64-linux = "sha256-smB13xev2TG1xUx4+06KRgYEnPMczpjBOOX7uC1APbE=";
          x86_64-linux = "sha256-+3TbLuL5Y2flLRicQgPVLs8KZQBqNYJYJ8P3etgX7g0=";
        };
      in
      lib.mapNullable (
        hash:
        fetchurl {
          inherit hash name;
          url = "${baseURL}/${name}.tar.gz";
        }
      ) (hashes.${effectiveStdenv.hostPlatform.system} or null);

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      tar -xzf "$src" -C "$out"

      mkdir -p "$static"
      moveToOutput "lib/libmathdx_static.a" "$static"

      runHook postInstall
    '';

    meta = {
      description = "library used to integrate cuBLASDx and cuFFTDx into Warp";
      homepage = "https://developer.nvidia.com/cublasdx-downloads";
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      license = with lib.licenses; [
        # By downloading and using the software, you agree to fully
        # comply with the terms and conditions of the NVIDIA Software
        # License Agreement.
        (
          nvidiaCudaRedist
          // {
            url = "https://developer.download.nvidia.cn/compute/mathdx/License.txt";
          }
        )

        # Some of the libmathdx routines were written by or derived
        # from code written by Meta Platforms, Inc. and affiliates and
        # are subject to the BSD License.
        bsd3

        # Some of the libmathdx routines were written by or derived from
        # code written by Victor Zverovich and are subject to the following
        # license:
        mit
      ];
      platforms = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      maintainers = with lib.maintainers; [ yzx9 ];
    };
  });
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
    hash = "sha256-zCRB92acxOiIFGjfRh2Cr1qq8pbhm+Rd011quMP/D88=";
  };

  patches =
    lib.optionals effectiveStdenv.hostPlatform.isDarwin [
      (replaceVars ./darwin-libcxx.patch {
        LIBCXX_DEV = llvmPackages.libcxx.dev;
        LIBCXX_LIB = llvmPackages.libcxx;
      })
      ./darwin-single-target.patch
    ]
    ++ lib.optionals standaloneSupport [
      (replaceVars ./standalone-llvm.patch {
        LLVM_DEV = llvmPackages.llvm.dev;
        LLVM_LIB = llvmPackages.llvm.lib;
        LIBCLANG_DEV = llvmPackages.libclang.dev;
        LIBCLANG_LIB = llvmPackages.libclang.lib;
      })
      ./standalone-cxx11-abi.patch
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
    # Broken tests on aarch64. Since unittest doesn't support disabling a
    # single test, and pytest isn't compatible, we patch the test file directly
    # instead.
    #
    # See: https://github.com/NVIDIA/warp/issues/552
    + lib.optionalString effectiveStdenv.hostPlatform.isAarch64 ''
      nixLog "patching $PWD/warp/tests/test_fem.py to disable broken tests on aarch64"
      substituteInPlace "$PWD/warp/tests/test_fem.py" \
        --replace-fail \
          'add_function_test(TestFem, "test_integrate_gradient", test_integrate_gradient, devices=devices)' \
          ""
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

  # NOTE: While normally we wouldn't include autoAddDriverRunpath for packages built from source, since Warp
  # will be loading GPU drivers at runtime, we need to inject the path to our video drivers.
  nativeBuildInputs = lib.optionals cudaSupport [
    autoAddDriverRunpath
    cudaPackages.cuda_nvcc
  ];

  buildInputs =
    lib.optionals standaloneSupport [
      llvmPackages.llvm
      llvmPackages.clang
      llvmPackages.libcxx
    ]
    ++ lib.optionals cudaSupport [
      (lib.getOutput "static" cudaPackages.cuda_nvcc) # dependency on nvptxcompiler_static; no dynamic version available
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
    testers.unit-tests = writeShellApplication {
      name = "warp-lang-unit-tests";
      runtimeInputs = [
        # Use the references from args
        (python.withPackages (_: [
          warp-lang
          jax
          torch
        ]))
        # Disable paddlepaddle interop tests: malloc(): unaligned tcache chunk detected
        #  (paddlepaddle.override { inherit cudaSupport; })
      ];
      text = ''
        python3 -m warp.tests
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
              # Many unit tests fail with segfaults on aarch64-linux, especially in the sim
              # and grad modules. However, other functionality generally works, so we don't
              # mark the package as broken.
              #
              # See: https://www.github.com/NVIDIA/warp/issues/{356,372,552}
              meta.broken = effectiveStdenv.hostPlatform.isAarch64 && effectiveStdenv.hostPlatform.isLinux;
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
