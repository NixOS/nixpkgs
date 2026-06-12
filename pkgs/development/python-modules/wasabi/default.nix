{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,

  # tests
  ipykernel,
  nbconvert,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "wasabi";
  version = "1.1.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-S7MAjwA4CdsMPii02vIJBuqHGiu0P5kUGX1UD08uCHg=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    ipykernel
    nbconvert
    typing-extensions
    pytestCheckHook
  ];

  pythonImportsCheck = [ "wasabi" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Lightweight console printing and formatting toolkit";
    homepage = "https://github.com/explosion/wasabi";
    changelog = "https://github.com/explosion/wasabi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    hasNoMaintainersButDependents = true;
  };
})
