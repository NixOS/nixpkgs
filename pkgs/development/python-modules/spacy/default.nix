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
}:

buildPythonPackage rec {
  pname = "spacy";
  version = "2.0.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mybdms7c40jvk8ak180n65anjiyg4c8gkaqwkzicrd1mxq3ngqj";
  };

  prePatch = ''
    substituteInPlace setup.py \
      --replace "regex==" "regex>=" \
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
