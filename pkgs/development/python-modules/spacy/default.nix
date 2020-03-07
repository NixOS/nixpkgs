{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytest
, preshed
, ftfy
, numpy
, murmurhash
, plac
, ujson
, dill
, requests
, thinc
, regex
, cymem
, pathlib
, msgpack
, msgpack-numpy
, jsonschema
, blis
, wasabi
, srsly
, catalogue
, setuptools
}:

buildPythonPackage rec {
  pname = "spacy";
  version = "2.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0shfjk6nhm6gzp5p88pz5k7bkg5dr3x9yvandkayqb2vsvkwj50x";
  };

  propagatedBuildInputs = [
   numpy
   murmurhash
   cymem
   preshed
   thinc
   plac
   ujson
   dill
   requests
   regex
   ftfy
   msgpack
   msgpack-numpy
   jsonschema
   blis
   wasabi
   srsly
   catalogue
   setuptools
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
