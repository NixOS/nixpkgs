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
  version = "2.0.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ghgbv819ff4777904p1kzayq1dj34i7853anvg859sak59r7pj1";
  };

  prePatch = ''
    substituteInPlace setup.py \
      --replace "regex==" "regex>=" \
      --replace "plac<1.0.0,>=0.9.6" "plac>=0.9.6" \
      --replace "thinc>=6.12.0,<6.13.0" "thinc>=6.12.0" \
      --replace "wheel>=0.32.0,<0.33.0" "wheel>=0.31.0"
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
