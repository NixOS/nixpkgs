{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  torch,
  torchvision,
}:

buildPythonPackage (finalAttrs: {
  pname = "torchprofile";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zhijian-liu";
    repo = "torchprofile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ynRrGHzroyv8T8fggJAag7u6XBOx+uN49HSIe46Bcek=";
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
    changelog = "https://github.com/zhijian-liu/torchprofile/releases/tag/${finalAttrs.src.tag}";
    description = "General and accurate MACs / FLOPs profiler for PyTorch models";
    homepage = "https://github.com/zhijian-liu/torchprofile";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
