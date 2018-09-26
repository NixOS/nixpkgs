{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, html5lib
, pytest
, preshed
, ftfy
, numpy
, murmurhash
, plac
, six
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
  version = "2.0.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b220ebee412c19613c26b2c1870b60473834bd686cec49553ce5f184164d3359";
  };

  prePatch = ''
    substituteInPlace setup.py \
      --replace "html5lib==" "html5lib>=" \
      --replace "regex==" "regex>=" \
      --replace "ftfy==" "ftfy>=" \
      --replace "msgpack-python==" "msgpack-python>=" \
      --replace "msgpack-numpy==" "msgpack-numpy>=" \
      --replace "thinc>=6.10.3,<6.11.0" "thinc>=6.10.3" \
      --replace "plac<1.0.0,>=0.9.6" "plac>=0.9.6"
  '';

  propagatedBuildInputs = [
   numpy
   murmurhash
   cymem
   preshed
   thinc
   plac
   six
   html5lib
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
