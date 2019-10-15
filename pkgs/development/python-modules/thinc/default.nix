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
  version = "7.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gkz4q53ps3vzz0ww154y0dv6nri5sli8yflh7c26maawvz8wiv8";
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
