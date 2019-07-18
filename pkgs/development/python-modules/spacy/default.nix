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
, msgpack-python
, msgpack-numpy
, jsonschema
, blis
, wasabi
, srsly
}:

buildPythonPackage rec {
  pname = "spacy";
  version = "2.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1s0a0vir9lg5q8n832kkadbajb4i4zl20zmdg3g20qlp4mcbn25p";
  };

  prePatch = ''
    substituteInPlace setup.py \
      --replace "plac<1.0.0,>=0.9.6" "plac>=0.9.6" \
      --replace "regex==" "regex>=" \
      --replace "wheel>=0.32.0,<0.33.0" "wheel>=0.32.0"
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
   msgpack-python
   msgpack-numpy
   jsonschema
   blis
   wasabi
   srsly
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
