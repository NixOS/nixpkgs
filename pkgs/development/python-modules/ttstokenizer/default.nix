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
  version = "1.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-akXiscw57CMp2JDdJq7wqeBeML41yLyFh7fTZwEBlVA=";
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

  meta = with lib; {
    description = "Tokenizer for Text to Speech (TTS) models";
    homepage = "https://pypi.org/project/ttstokenizer";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ happysalada ];
  };
}
