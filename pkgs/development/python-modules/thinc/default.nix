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
  version = "7.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c98491b083165f48bda95f5533f7d9dbd3980d32ad621bfe579ff08ef625a4d3";
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

  postPatch = ''
    substituteInPlace setup.py \
      --replace "blis>=0.4.0,<0.5.0" "blis>=0.4.0,<1.0" \
      --replace "catalogue>=0.0.7,<1.1.0" "catalogue>=0.0.7,<3.0" \
      --replace "plac>=0.9.6,<1.2.0" "plac>=0.9.6,<2.0" \
      --replace "srsly>=0.0.6,<1.1.0" "srsly>=0.0.6,<3.0"
  '';

  checkPhase = ''
    pytest thinc/tests
  '';

  pythonImportsCheck = [ "thinc" ];

  meta = with stdenv.lib; {
    description = "Practical Machine Learning for NLP in Python";
    homepage = "https://github.com/explosion/thinc";
    license = licenses.mit;
    maintainers = with maintainers; [ aborsu danieldk sdll ];
    };
}
