{
  lib,
  torch,
  buildPythonPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  libpng,
  ninja,
  which,

  # buildInputs
  libjpeg_turbo,

  # dependencies
  numpy,
  pillow,
  scipy,

  # tests
  pytest,
  writableTmpDirAsHomeHook,
}:

let
  inherit (torch) cudaCapabilities cudaPackages cudaSupport;

in
buildPythonPackage.override { inherit (torch) stdenv; } (finalAttrs: {
  pname = "torchvision";
  version = "0.26.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "vision";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FOdDGY3v8yWBhtNo9tZP79/xwrc7AoIY5Y1ZABzWe6g=";
  };

  nativeBuildInputs = [
    libpng
    ninja
    which
  ]
  ++ lib.optionals cudaSupport [ cudaPackages.cuda_nvcc ];

  buildInputs = [
    libjpeg_turbo
    libpng
    torch.cxxdev
  ];

  dependencies = [
    numpy
    pillow
    torch
    scipy
  ];

  env = {
    TORCHVISION_INCLUDE = "${libjpeg_turbo.dev}/include/";
    TORCHVISION_LIBRARY = "${libjpeg_turbo}/lib/";
  }
  // lib.optionalAttrs cudaSupport {
    # At of 2026-03-27, the default `cudaPackages` version is 12.9.1
    # According to Nvidia, it should support GCC versions up to 14.x:
    # -> https://docs.nvidia.com/cuda/archive/12.9.1/cuda-installation-guide-linux/index.html#host-compiler-support-policy
    # However, PyTorch's *strict* upper bound is 14.0:
    # -> https://github.com/pytorch/pytorch/blob/v2.11.0/torch/utils/cpp_extension.py#L75
    # Hence, the build fails with:
    #   RuntimeError: The current installed version of g++ (14.3.0) is greater than the maximum
    #   required version by CUDA 12.9. Please make sure to use an adequate version of g++
    #   (>=6.0.0, <14.0).
    # Hence, we disable the version check to silence the error:
    TORCH_DONT_CHECK_COMPILER_ABI = 1;

    TORCH_CUDA_ARCH_LIST = "${lib.concatStringsSep ";" cudaCapabilities}";
    FORCE_CUDA = 1;
  };

  # tests download big datasets, models, require internet connection, etc.
  doCheck = false;

  pythonImportsCheck = [ "torchvision" ];

  nativeCheckInputs = [
    pytest
    writableTmpDirAsHomeHook
  ];

  checkPhase = ''
    py.test test --ignore=test/test_datasets_download.py
  '';

  meta = {
    description = "PyTorch vision library";
    homepage = "https://pytorch.org/";
    changelog = "https://github.com/pytorch/vision/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    platforms = with lib.platforms; linux ++ lib.optionals (!cudaSupport) darwin;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
