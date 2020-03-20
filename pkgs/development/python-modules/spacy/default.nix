{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytest
, blis
, catalogue
, cymem
, jsonschema
, murmurhash
, numpy
, pathlib
, plac
, preshed
, requests
, setuptools
, srsly
, thinc
, wasabi
}:

buildPythonPackage rec {
  pname = "spacy";
  version = "2.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fgm1zlw8mjhmk64skxs79ymhcningml13y9c9fy7rj1b1yadwzh";
  };

  propagatedBuildInputs = [
   blis
   catalogue
   cymem
   jsonschema
   murmurhash
   numpy
   plac
   preshed
   requests
   setuptools
   srsly
   thinc
   wasabi
  ] ++ lib.optional (pythonOlder "3.4") pathlib;

  checkInputs = [
    pytest
  ];

  doCheck = false;
  # checkPhase = ''
  #   ${python.interpreter} -m pytest spacy/tests --vectors --models --slow
  # '';

  meta = with lib; {
    description = "Industrial-strength Natural Language Processing (NLP) with Python and Cython";
    homepage = https://github.com/explosion/spaCy;
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk sdll ];
    };
}
