{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, which
, pybind11
, scipy
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
      libcurand
      libcusolver
      libcusparse
    ];
  };
in

buildPythonPackage rec {
  pname = "torch-cluster";
  version = "1.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rusty1s";
    repo = "pytorch_cluster";
    rev = "refs/tags/${version}";
    hash = "sha256-ok3rFjp+Q/oqIRBSIHJy6yvhELkOSzwgtAcJTZO6ZS8=";
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
    scipy
    torch
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    rm -r torch_cluster
  '';

  pythonImportsCheck = [ "torch_cluster" ];

  meta = with lib; {
    description = "PyTorch Extension Library of Optimized Graph Cluster Algorithms";
    homepage = "https://github.com/rusty1s/pytorch_cluster";
    changelog = "https://github.com/rusty1s/pytorch_cluster/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
