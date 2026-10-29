{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  einops,
  numpy,
  safetensors,
  torch,
  torchvision,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "spandrel";
  version = "0.4.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-/vpOqWbGpbdyHc8k8+IGKlqWo5XIvty1cPtVlx/cvMs=";
  };

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

  meta = {
    description = "PyTorch architecture support for super-resolution, restoration, and inpainting models";
    homepage = "https://github.com/chaiNNer-org/spandrel";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ caniko ];
  };
})
