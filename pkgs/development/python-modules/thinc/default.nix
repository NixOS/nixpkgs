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
, msgpack
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
, blis
, srsly
, wasabi
}:

buildPythonPackage rec {
  pname = "thinc";
  version = "7.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "808caccafab95aa74c21695248b26279792cd7d07d94fd97f181020f318f024a";
  };

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    Accelerate CoreFoundation CoreGraphics CoreVideo
  ]);

  propagatedBuildInputs = [
   blis
   cython
   cymem
   msgpack-numpy
   msgpack
   preshed
   numpy
   murmurhash
   tqdm
   cytoolz
   plac
   six
   srsly
   wrapt
   dill
   wasabi
  ] ++ lib.optional (pythonOlder "3.4") pathlib;


  checkInputs = [
    hypothesis
    mock
    pytest
  ];

  prePatch = ''
    substituteInPlace setup.py \
      --replace "plac>=0.9.6,<1.0.0" "plac>=0.9.6"
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
    maintainers = with maintainers; [ aborsu danieldk sdll ];
    };
}
