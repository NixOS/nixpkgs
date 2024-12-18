{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  libjpeg_turbo,
  libpng,
  ninja,
  numpy,
  pillow,
  pytest,
  scipy,
  torch,
  which,
}:

let
  inherit (torch) cudaCapabilities cudaPackages cudaSupport;
  inherit (cudaPackages) backendStdenv;

  pname = "torchvision";
  version = "0.18.1";
in
buildPythonPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "vision";
    rev = "refs/tags/v${version}";
    hash = "sha256-aFm6CyoMA8HtpOAVF5Q35n3JRaOXYswWEqfooORUKsw=";
  };

  nativeBuildInputs = [
    libpng
    ninja
    which
  ] ++ lib.optionals cudaSupport [ cudaPackages.cuda_nvcc ];

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

  preConfigure =
    ''
      export TORCHVISION_INCLUDE="${libjpeg_turbo.dev}/include/"
      export TORCHVISION_LIBRARY="${libjpeg_turbo}/lib/"
    ''
    # NOTE: We essentially override the compilers provided by stdenv because we don't have a hook
    #   for cudaPackages to swap in compilers supported by NVCC.
    + lib.optionalString cudaSupport ''
      export CC=${backendStdenv.cc}/bin/cc
      export CXX=${backendStdenv.cc}/bin/c++
      export TORCH_CUDA_ARCH_LIST="${lib.concatStringsSep ";" cudaCapabilities}"
      export FORCE_CUDA=1
    '';

  # tries to download many datasets for tests
  doCheck = false;

  pythonImportsCheck = [ "torchvision" ];
  checkPhase = ''
    HOME=$TMPDIR py.test test --ignore=test/test_datasets_download.py
  '';

  nativeCheckInputs = [ pytest ];

  meta = {
    description = "PyTorch vision library";
    homepage = "https://pytorch.org/";
    license = lib.licenses.bsd3;
    platforms = with lib.platforms; linux ++ lib.optionals (!cudaSupport) darwin;
    maintainers = with lib.maintainers; [ ericsagnes ];
  };
}
