{
  lib,
  buildPythonPackage,
  fetchPypi,

  # tests
  ipykernel,
  nbconvert,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "wasabi";
  version = "1.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-S7MAjwA4CdsMPii02vIJBuqHGiu0P5kUGX1UD08uCHg=";
  };

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
    homepage = "https://github.com/ines/wasabi";
    changelog = "https://github.com/ines/wasabi/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
