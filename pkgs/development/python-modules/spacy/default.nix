{ stdenv
, pkgs
, buildPythonPackage
, python
, fetchPypi
, html5lib
, pytest
, cython
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
, pip
, regex
}:

buildPythonPackage rec {
  pname = "spacy";
  version = "2.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ihkhflhyz67bp73kfjqfrbcgdxi2msz5asbrh0pkk590c4vmms5";
  };

  prePatch = ''
    substituteInPlace setup.py \
      --replace "html5lib==" "html5lib>=" \
      --replace "regex==" "regex>=" \
      --replace "ftfy==" "ftfy>=" \
      --replace "msgpack-python==" "msgpack-python>=" \
      --replace "msgpack-numpy==" "msgpack-numpy>=" \
      --replace "pathlib" "pathlib; python_version<\"3.4\""
  '';

  propagatedBuildInputs = [
   cython
   dill
   html5lib
   murmurhash
   numpy
   plac
   preshed
   regex
   requests
   six
   thinc
   ujson
   ftfy
  ];

  checkInputs = [
    pytest
  ];

  doCheck = false;
  # checkPhase = ''
  #   ${python.interpreter} -m pytest spacy/tests --vectors --models --slow
  # '';

  meta = with stdenv.lib; {
    description = "Industrial-strength Natural Language Processing (NLP) with Python and Cython";
    homepage = https://github.com/explosion/spaCy;
    license = licenses.mit;
    maintainers = with maintainers; [ sdll ];
    };
}
