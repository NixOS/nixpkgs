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
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zhijian-liu";
    repo = "torchprofile";
    tag = "v${version}";
    hash = "sha256-t8ICoA6jiU3u9TywMjZeFZdMnbWEel4LoPWhun0kHI0=";
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
    changelog = "https://github.com/zhijian-liu/torchprofile/releases/tag/${src.tag}";
    description = "General and accurate MACs / FLOPs profiler for PyTorch models";
    homepage = "https://github.com/zhijian-liu/torchprofile";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
