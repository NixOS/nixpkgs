{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, parallel-hashmap
, which
, pybind11
, scipy
, torch
, torch-scatter
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
  pname = "torch-sparse";
  version = "0.6.17";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rusty1s";
    repo = "pytorch_sparse";
    rev = "refs/tags/${version}";
    hash = "sha256-SCBSWt2uDfHL/Bnv0xrZ0T2DagTGIU2+jwxPMtDAAWU=";
  };

  nativeBuildInputs = [
    which
  ] ++ lib.optionals cudaSupport [
    cuda-redist
  ];

  buildInputs = [
    parallel-hashmap
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
    scipy
    torch
    torch-scatter
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    rm -r torch_sparse
  '';

  pythonImportsCheck = [ "torch_sparse" ];

  meta = with lib; {
    description = "PyTorch Extension Library of Optimized Autograd Sparse Matrix Operations";
    homepage = "https://github.com/rusty1s/pytorch_sparse";
    changelog = "https://github.com/rusty1s/pytorch_sparse/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
