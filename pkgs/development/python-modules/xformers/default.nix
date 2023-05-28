{
  buildPythonPackage,
  config,
  cudaPackages,
  fetchFromGitHub,
  lib,
  symlinkJoin,
  # nativeBuildInputs
  git,
  ninja,
  which,
  # propagatedBuildInputs
  numpy,
  pyre-extensions,
  torch,
}: let
  cudaSupport = config.cudaSupport or false;

  # Build-time dependencies
  cuda-native-redist = symlinkJoin {
    name = "cuda-native-redist-${cudaPackages.cudaVersion}";
    paths = with cudaPackages; [
      cuda_cccl #include <thrust/*>
      cuda_cudart #include <cuda_runtime.h>
      cuda_nvcc
      libcublas #include <cublas_v2.h>
      libcurand #include <curand_kernel.h>
      libcusolver #include <cusolverDn.h>
      libcusparse #include <cusparse.h>
    ];
  };

  attrs = {
    pname = "xformers";
    version = "0.0.20";

    src = fetchFromGitHub {
      owner = "facebookresearch";
      repo = attrs.pname;
      rev = "v${attrs.version}";
      fetchSubmodules = true;
      leaveDotGit = true;
      hash = "sha256-vNZ69KMID6NRtlUSFXxXcoTbY5qFZSD9pnsLnQ0Q6MQ=";
    };

    nativeBuildInputs = [
      cuda-native-redist
      git
      ninja
      which
    ];

    propagatedBuildInputs = [
      numpy
      pyre-extensions
      torch
    ];

    postPatch = ''
      substituteInPlace xformers/__init__.py \
        --replace "_is_functorch_available: bool = False" "_is_functorch_available: bool = True"
    '';

    preBuild =
      ''
        export XFORMERS_BUILD_TYPE=Release
      ''
      + lib.strings.optionalString cudaSupport ''
        export TORCH_CUDA_ARCH_LIST="${lib.strings.concatStringsSep ";" torch.cudaCapabilities}"
        export CC="${cudaPackages.backendStdenv.cc}/bin/cc"
        export CXX="${cudaPackages.backendStdenv.cc}/bin/c++"
      '';

    # Note: Tests require ragged_inference, which is in the experimental module and is not built
    # by default.
    doCheck = false;
    pythonImportsCheck = [attrs.pname];

    passthru = {
      inherit cudaSupport cudaPackages;
      cudaCapabilities = lib.lists.optionals cudaSupport torch.cudaCapabilities;
    };

    meta = with lib; {
      description = "Hackable and optimized Transformers building blocks, supporting a composable construction";
      homepage = "https://github.com/facebookresearch/xformers";
      license = licenses.bsd3;
      platforms = platforms.linux;
      broken = cudaSupport != torch.cudaSupport;
      maintainers = with maintainers; [connorbaker];
    };
  };
in
  buildPythonPackage attrs
