{ stdenv
, lib
, pkgs
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytest
, cython
, cymem
, msgpack-numpy
, msgpack-python
, preshed
, numpy
, python
, murmurhash
, pathlib
, hypothesis
, tqdm
, cytoolz
, plac
, six
, mock
, termcolor
, wrapt
, dill
}:

buildPythonPackage rec {
  pname = "thinc";
  version = "6.11.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "028a014192e1914c151222794781d14e1c9fddf47a859aa36077f07871d0c30a";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "msgpack-python==" "msgpack-python>=" \
      --replace "msgpack-numpy==" "msgpack-numpy>="
  '';

  propagatedBuildInputs = [
   cython
   cymem
   msgpack-numpy
   msgpack-python
   preshed
   numpy
   murmurhash
   pytest
   hypothesis
   tqdm
   cytoolz
   plac
   six
   mock
   termcolor
   wrapt
   dill
  ] ++ lib.optional (pythonOlder "3.4") pathlib;


  checkInputs = [
    pytest
  ];

  prePatch = ''
    substituteInPlace setup.py --replace \
      "'pathlib>=1.0.0,<2.0.0'," \
      "\"pathlib>=1.0.0,<2.0.0; python_version<'3.4'\","

    substituteInPlace setup.py --replace \
      "'cytoolz>=0.8,<0.9'," \
      "'cytoolz>=0.8',"
  '';

  # Cannot find cython modules.
  doCheck = false;

  checkPhase = ''
    pytest thinc/tests
  '';

  meta = with stdenv.lib; {
    description = "Practical Machine Learning for NLP in Python";
    homepage = https://github.com/explosion/thinc;
    license = licenses.mit;
    maintainers = with maintainers; [ aborsu sdll ];
    };
}
