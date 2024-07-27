{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, which
, pybind11
, torch
, symlinkJoin
}:
let
  inherit (torch) cudaCapabilities cudaPackages cudaSupport;
  inherit (cudaPackages) backendStdenv cudaVersion;

  cuda-redist = symlinkJoin {
    name = "cuda-redist-${cudaVersion}";
    paths = with cudaPackages; [
      cuda_cccl
      cuda_cudart
      cuda_nvcc
      libcublas
      libcusolver
      libcusparse
    ];
  };
in

buildPythonPackage rec {
  pname = "torch-spline-conv";
  version = "1.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rusty1s";
    repo = "pytorch_spline_conv";
    rev = "refs/tags/${version}";
    hash = "sha256-B7I0vs7SoJ99N9xYRAOsvdbb0DGw6xn1d27fshmqTQI=";
  };

  nativeBuildInputs = [
    which
  ] ++ lib.optionals cudaSupport [
    cuda-redist
  ];

  buildInputs = [
    pybind11
  ];

  preBuild = lib.optionalString cudaSupport ''
    export CC=${backendStdenv.cc}/bin/cc
    export CXX=${backendStdenv.cc}/bin/c++
  '';

  env = lib.optionalAttrs cudaSupport {
    FORCE_CUDA = lib.optionalString cudaSupport "1";
    TORCH_CUDA_ARCH_LIST = lib.concatStringsSep ";" cudaCapabilities;
  };

  enableParallelBuilding = true;

  propagatedBuildInputs = [
    torch
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    rm -r torch_spline_conv
  '';

  pythonImportsCheck = [ "torch_spline_conv" ];

  meta = with lib; {
    description = "Implementation of the Spline-Based Convolution Operator of SplineCNN in PyTorch";
    homepage = "https://github.com/rusty1s/pytorch_spline_conv";
    changelog = "https://github.com/rusty1s/pytorch_spline_conv/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
