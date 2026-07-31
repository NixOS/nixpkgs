{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "srt";
  version = "3.5.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SIQxUEOk8HQP0fh47WyqN2rAbXDhNfMGptxEYy7tDMA=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "srt" ];

  meta = {
    homepage = "https://github.com/cdown/srt";
    description = "Tiny but featureful Python library for parsing, modifying, and composing SRT files";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
