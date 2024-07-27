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
  pname = "torch-scatter";
  version = "2.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rusty1s";
    repo = "pytorch_scatter";
    rev = "refs/tags/${version}";
    hash = "sha256-oAxWTX412dWFb2DYo9UbN+N1BUvg4nB/JL1cMoJIkjw=";
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
    rm -r torch_scatter
  '';

  pythonImportsCheck = [ "torch_scatter" ];

  meta = with lib; {
    description = "PyTorch Extension Library of Optimized Scatter Operations";
    homepage = "https://github.com/rusty1s/pytorch_scatter";
    changelog = "https://github.com/rusty1s/pytorch_scatter/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
