{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  scipy,
  setuptools,
  torch,
}:

buildPythonPackage rec {
  pname = "torch-cluster";
  version = "1.6.3";
  src = fetchFromGitHub {
    owner = "rusty1s";
    repo = "pytorch_cluster";
    tag = version;
    hash = "sha256-+1IJKO4Oq+soLAznsVnKy1Of7gcmZ7G48eJJIL4eKM8=";
  };
  pyproject = true;

  build-system = [ setuptools ];

  dependencies = [
    scipy
    torch
  ];

  pythonImportsCheck = [ "torch_cluster" ];

  meta = with lib; {
    description = "PyTorch Extension Library for High-Performance Clustering Algorithms";
    homepage = "https://github.com/rusty1s/pytorch_cluster";
    license = licenses.mit;
  };
}
