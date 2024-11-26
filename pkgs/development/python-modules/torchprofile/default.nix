{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  torch,
  torchvision,
}:

buildPythonPackage rec {
  pname = "torchprofile";
  version = "0.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zhijian-liu";
    repo = "torchprofile";
    rev = "refs/tags/v${version}";
    hash = "sha256-6vxZHQwBjKpy288wcANdJ9gmvIOZloLv+iN76TtqYAI=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "torchvision"
  ];

  dependencies = [
    numpy
    torch
    torchvision
  ];

  pythonImportsCheck = [
    "torchprofile"
  ];

  meta = {
    changelog = "https://github.com/zhijian-liu/torchprofile/releases/tag/v${version}";
    description = "General and accurate MACs / FLOPs profiler for PyTorch models";
    homepage = "https://github.com/zhijian-liu/torchprofile";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
