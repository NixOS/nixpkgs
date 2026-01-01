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
    hash = "sha256-SIQxUEOk8HQP0fh47WyqN2rAbXDhNfMGptxEYy7tDMA=";
  };

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "srt" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/cdown/srt";
    description = "Tiny but featureful Python library for parsing, modifying, and composing SRT files";
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    homepage = "https://github.com/cdown/srt";
    description = "Tiny but featureful Python library for parsing, modifying, and composing SRT files";
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
