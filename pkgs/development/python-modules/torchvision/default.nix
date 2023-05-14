{ buildPythonPackage
, fetchFromGitHub
, lib
, libjpeg_turbo
, libpng
, ninja
, numpy
, pillow
, pytest
, scipy
, symlinkJoin
, torch
, which
}:

let
  inherit (torch) cudaCapabilities cudaPackages cudaSupport;
  inherit (cudaPackages) backendStdenv cudaVersion;

  # NOTE: torchvision doesn't use cudnn; torch does!
  #   For this reason it is not included.
  cuda-common-redist = with cudaPackages; [
    cuda_cccl # <thrust/*>
    libcublas # cublas_v2.h
    libcusolver # cusolverDn.h
    libcusparse # cusparse.h
  ];

  cuda-native-redist = symlinkJoin {
    name = "cuda-native-redist-${cudaVersion}";
    paths = with cudaPackages; [
      cuda_cudart # cuda_runtime.h
      cuda_nvcc
    ] ++ cuda-common-redist;
  };

  cuda-redist = symlinkJoin {
    name = "cuda-redist-${cudaVersion}";
    paths = cuda-common-redist;
  };

  pname = "torchvision";
  version = "0.15.1";
in
buildPythonPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "vision";
    rev = "refs/tags/v${version}";
    hash = "sha256-CQS2IXb8YSLrrkn/7BsO4Me5Cv0eXgMAKXM4rGzr0Bw=";
  };

  nativeBuildInputs = [ libpng ninja which ] ++ lib.optionals cudaSupport [ cuda-native-redist ];

  buildInputs = [ libjpeg_turbo libpng ] ++ lib.optionals cudaSupport [ cuda-redist ];

  propagatedBuildInputs = [ numpy pillow torch scipy ];

  preConfigure = ''
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

  meta = with lib; {
    description = "PyTorch vision library";
    homepage = "https://pytorch.org/";
    license = licenses.bsd3;
    platforms = with platforms; linux ++ lib.optionals (!cudaSupport) darwin;
    maintainers = with maintainers; [ ericsagnes ];
  };
}
