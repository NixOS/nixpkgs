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
  version = "2.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01mmgfn7r288jklz6902xfb5dbih0h29s9p0na12gyj2c7gnvf5i";
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
    maintainers = with maintainers; [ sdll ];
    };
}
