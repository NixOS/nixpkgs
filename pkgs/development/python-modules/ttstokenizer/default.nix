{
  lib,
  buildPythonPackage,
  fetchPypi,
  anyascii,
  inflect,
  nltk,
  numpy,
}:

buildPythonPackage rec {
  pname = "ttstokenizer";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HtDXDKlZ3jpwIgb5DvaqurEkRe8TRJ2xqKl2IKElnKU=";
  };

  propagatedBuildInputs = [
    anyascii
    inflect
    nltk
    numpy
  ];

  pythonImportsCheck = [ "ttstokenizer" ];

  # no tests
  doCheck = false;

  meta = {
    description = "Tokenizer for Text to Speech (TTS) models";
    homepage = "https://pypi.org/project/ttstokenizer";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
