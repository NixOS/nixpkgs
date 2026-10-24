{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  anyascii,
  inflect,
  nltk,
  numpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "ttstokenizer";
  version = "1.1.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-akXiscw57CMp2JDdJq7wqeBeML41yLyFh7fTZwEBlVA=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
