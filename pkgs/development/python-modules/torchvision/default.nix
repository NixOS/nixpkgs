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
  version = "0.27.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "vision";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XFbFC77UHC9WVhZepEK+7JpWbTpTrGizx8NMcRlwX74=";
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
