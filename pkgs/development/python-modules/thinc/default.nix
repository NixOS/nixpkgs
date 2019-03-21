{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytest
, cython
, cymem
, darwin
, msgpack-numpy
, msgpack-python
, preshed
, numpy
, murmurhash
, pathlib
, hypothesis
, tqdm
, cytoolz
, plac
, six
, mock
, wrapt
, dill
}:

buildPythonPackage rec {
  pname = "thinc";
  version = "6.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kkp8b3xcs3yn3ia5sxrh086c9xv27s2khdxd17abdypxxa99ich";
  };

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    Accelerate CoreFoundation CoreGraphics CoreVideo
  ]);

  propagatedBuildInputs = [
   cython
   cymem
   msgpack-numpy
   msgpack-python
   preshed
   numpy
   murmurhash
   tqdm
   cytoolz
   plac
   six
   wrapt
   dill
  ] ++ lib.optional (pythonOlder "3.4") pathlib;


  checkInputs = [
    hypothesis
    mock
    pytest
  ];

  prePatch = ''
    substituteInPlace setup.py \
      --replace "pathlib==1.0.1" "pathlib>=1.0.0,<2.0.0" \
      --replace "plac>=0.9.6,<1.0.0" "plac>=0.9.6" \
      --replace "msgpack-numpy<0.4.4" "msgpack-numpy"
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
