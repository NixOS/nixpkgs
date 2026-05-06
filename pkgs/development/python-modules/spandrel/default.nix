{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  setuptools,

  einops,
  numpy,
  safetensors,
  torch,
  torchvision,
  typing-extensions,
}:
buildPythonPackage rec {
  pname = "spandrel";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chaiNNer-org";
    repo = "spandrel";
    rev = "v${version}";
    hash = "sha256-saRSosJ/pXmhLX5VqK3IBwT1yo14kD4nwNw0bCT2o5w=";
  };
  # weird nested pyproject.toml
  sourceRoot = "${src.name}/libs/spandrel";

  build-system = [ setuptools ];

  dependencies = [
    einops
    numpy
    safetensors
    torch
    torchvision
    typing-extensions
  ];

  pythonImportsCheck = [ "spandrel" ];

  # not running pytest tests as you'd need to `cd` back to the root
  # and the tests all attempt to fetch remote models

  meta = {
    description = "Library for loading and running pre-trained PyTorch models";
    homepage = "https://github.com/chaiNNer-org/spandrel/";
    license = lib.licenses.mit; # gpl3 prior to 0.3.0
    maintainers = with lib.maintainers; [
      jk
    ];
  };
}
