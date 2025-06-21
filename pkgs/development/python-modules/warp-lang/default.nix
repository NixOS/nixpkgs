{
  config,
  lib,
  stdenv,
  buildPythonPackage,
  fetchurl,
  fetchFromGitHub,
  replaceVars,
  build,
  setuptools,
  numpy,
  llvmPackages,
  cudaPackages,
  unittestCheckHook,
  jax,
  torch,
  nix-update-script,

  # Use standalone LLVM-based JIT compiler and CPU device support
  standaloneSupport ? true,

  # Use CUDA toolchain and GPU device support
  cudaSupport ? config.cudaSupport,

  # Build Warp with MathDx support (requires CUDA support)
  # Most linear-algebra tile operations like tile_cholesky(), tile_fft(),
  # and tile_matmul() require Warp to be built with the MathDx library.
  libmathdxSupport ? cudaSupport && stdenv.hostPlatform.isLinux,
}:

let
  version = "1.7.2.post1";

  libmathdx = stdenv.mkDerivation (finalAttrs: {
    pname = "libmathdx";
    version = "0.2.0";

    src =
      let
        inherit (stdenv.hostPlatform) system;
        selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");

        suffix = selectSystem {
          x86_64-linux = "Linux-x86_64";
          aarch64-linux = "Linux-aarch64";
          x86_64-windows = "win32-x86_64";
        };

        # nix-hash --type sha256 --to-sri $(nix-prefetch-url "https://...")
        hash = selectSystem {
          x86_64-linux = "sha256-Lk+PxWFvyQGRClFdmyuo4y7HBdR7pigOhMyEzajqbmg=";
          aarch64-linux = "sha256-6tH9YH98kSvDiut9rQEU5potEpeKqma/QtrCHLxwRLo=";
          x86_64-windows = "sha256-B8qwj7UzOXEDZh2oT3ip1qW0uqtygMsyfcbhh5Dgc8U=";
        };
      in
      fetchurl {
        url = "https://developer.nvidia.com/downloads/compute/cublasdx/redist/cublasdx/libmathdx-${suffix}-${finalAttrs.version}.tar.gz";
        inherit hash;
      };

    unpackPhase = ''
      runHook preUnpack

      mkdir unpacked
      cd unpacked
      tar -xzf $src
      export sourceRoot=$(pwd)

      runHook postUnpack
    '';

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      cp -rT "$sourceRoot" "$out"

      runHook postInstall
    '';

    meta = {
      description = "library used to integrate cuBLASDx and cuFFTDx into Warp";
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
        bsd
      ];
      platforms = with lib.platforms; linux ++ [ "x86_64-windows" ];
      maintainers = with lib.maintainers; [ yzx9 ];
    };
  });
in
buildPythonPackage {
  pname = "warp-lang";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "warp";
    tag = "v${version}";
    hash = "sha256-cT0CrD71nNZnQMimGrmnSQl6RQx4MiUv2xBFPWNI/0s=";
  };

  patches =
    lib.optionals stdenv.hostPlatform.isDarwin [
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
    lib.optionalString (!stdenv.cc.isGNU) ''
      substituteInPlace warp/build_dll.py \
        --replace-fail "g++" "${lib.getExe stdenv.cc}"
    ''
    # Broken tests on aarch64. Since unittest doesn't support disabling a
    # single test, and pytest isn't compatible, we patch the test file directly
    # instead.
    #
    # See: https://github.com/NVIDIA/warp/issues/552
    + lib.optionalString stdenv.hostPlatform.isAarch64 ''
      substituteInPlace warp/tests/test_fem.py \
        --replace-fail "add_function_test(TestFem, \"test_integrate_gradient\", test_integrate_gradient, devices=devices)" ""
    '';

  build-system = [
    build
    setuptools
  ];

  dependencies = [
    numpy
  ];

  nativeBuildInputs = lib.optionals libmathdxSupport [
    libmathdx
    cudaPackages.libcublas
    cudaPackages.libcufft
    cudaPackages.libnvjitlink
  ];

  buildInputs =
    lib.optionals standaloneSupport [
      llvmPackages.llvm
      llvmPackages.clang
      llvmPackages.libcxx
    ]
    ++ lib.optionals cudaSupport [
      cudaPackages.cudatoolkit
      cudaPackages.cuda_cudart
      cudaPackages.cuda_nvcc
      cudaPackages.cuda_nvrtc
    ];

  preBuild =
    let
      buildOptions =
        lib.optionals (!standaloneSupport) [
          "--no_standalone"
        ]
        ++ lib.optionals cudaSupport [
          "--cuda_path=${cudaPackages.cudatoolkit}"
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
      python build_lib.py ${buildOptionString}
    '';

  pythonImportsCheck = [
    "warp"
  ];

  # Many unit tests fail with segfaults on aarch64-linux, especially in the sim
  # and grad modules. However, other functionality generally works, so we don't
  # mark the package as broken.
  #
  # See: https://www.github.com/NVIDIA/warp/issues/{356,372,552}
  doCheck = !(stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux);

  nativeCheckInputs = [
    unittestCheckHook
    (jax.override { inherit cudaSupport; })
    (torch.override { inherit cudaSupport; })

    # # Disable paddlepaddle interop tests: malloc(): unaligned tcache chunk detected
    #  (paddlepaddle.override { inherit cudaSupport; })
  ];

  preCheck = ''
    export WARP_CACHE_PATH=$(mktemp -d) # warp.config.kernel_cache_dir
  '';

  passthru.updateScript = nix-update-script { };

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
