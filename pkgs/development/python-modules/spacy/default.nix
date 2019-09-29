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
, setuptools
}:

buildPythonPackage rec {
  pname = "spacy";
  version = "2.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dja0crbai2n1l19m0hkv2fkj9r6zzy5ijd6dffp60v7lrch8lcw";
  };

  prePatch = ''
    substituteInPlace setup.py \
      --replace "plac<1.0.0,>=0.9.6" "plac>=0.9.6"
  '';

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
