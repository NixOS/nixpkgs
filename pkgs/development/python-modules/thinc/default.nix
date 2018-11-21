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
, termcolor
, wrapt
, dill
}:

buildPythonPackage rec {
  pname = "thinc";
  version = "6.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lfdf08v7rrj9b29z2vf8isaqa0zh16acw9im8chkqsh8bay4ykm";
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
    substituteInPlace setup.py \
      --replace "pathlib==1.0.1" "pathlib>=1.0.0,<2.0.0" \
      --replace "plac>=0.9.6,<1.0.0" "plac>=0.9.6" \
      --replace "wheel>=0.32.0,<0.33.0" "wheel>=0.31.0"
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
