{
  lib,
  buildPythonPackage,
  fetchPypi,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "srt";
  version = "3.5.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SIQxUEOk8HQP0fh47WyqN2rAbXDhNfMGptxEYy7tDMA=";
  };

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "srt" ];

  meta = with lib; {
    homepage = "https://github.com/cdown/srt";
    description = "Tiny but featureful Python library for parsing, modifying, and composing SRT files";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
