{
  lib,
  stdenv,
  torch,
  buildPythonPackage,
  darwinMinVersionHook,
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

  pname = "torchvision";
  version = "0.24.1";
in
buildPythonPackage {
  format = "setuptools";
  inherit pname version;

  stdenv = torch.stdenv;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "vision";
    tag = "v${version}";
    hash = "sha256-ddJWD2xjoNAuyZIaZD7ctcuSQZ9lSUGExWCq1W5prI8=";
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
    changelog = "https://github.com/pytorch/vision/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    platforms = with lib.platforms; linux ++ lib.optionals (!cudaSupport) darwin;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
