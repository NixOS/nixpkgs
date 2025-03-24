{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  torch,
}:

buildPythonPackage rec {
  pname = "torch-scatter";
  version = "2.1.2";
  src = fetchFromGitHub {
    owner = "rusty1s";
    repo = "pytorch_scatter";
    tag = version;
    hash = "sha256-dmJrsWoFsqFlrgfbFHeD5f//qUg0elmksIZG8vXXShc=";
  };
  pyproject = true;

  build-system = [ setuptools ];

  dependencies = [ torch ];

  pythonImportsCheck = [ "torch_scatter" ];

  meta = with lib; {
    description = "PyTorch Extension Library of Optimized Scatter Operations";
    homepage = "https://github.com/rusty1s/pytorch_scatter";
    license = licenses.mit;
  };
}
