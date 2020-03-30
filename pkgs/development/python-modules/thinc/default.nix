{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytest
, blis
, catalogue
, cymem
, cython
, darwin
, hypothesis
, mock
, murmurhash
, numpy
, pathlib
, plac
, preshed
, srsly
, tqdm
, wasabi
}:

buildPythonPackage rec {
  pname = "thinc";
  version = "7.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f2qpjb8nfdklqp3vf6m36bklydlnr8y8v207p8d2gmapzhrngjj";
  };

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    Accelerate CoreFoundation CoreGraphics CoreVideo
  ]);

  propagatedBuildInputs = [
   blis
   catalogue
   cymem
   cython
   murmurhash
   numpy
   plac
   preshed
   srsly
   tqdm
   wasabi
  ] ++ lib.optional (pythonOlder "3.4") pathlib;


  checkInputs = [
    hypothesis
    mock
    pytest
  ];

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
