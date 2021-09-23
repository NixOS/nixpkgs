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
, plac
, preshed
, pydantic
, srsly
, tqdm
, typing-extensions
, wasabi
}:

buildPythonPackage rec {
  pname = "thinc";
  version = "8.0.10";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07q04k552f8zl989yl9409b2p6mpf93qa5sa3rgqmgp64j6xpr5m";
  };

  buildInputs = [
    cython
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    Accelerate
    CoreFoundation
    CoreGraphics
    CoreVideo
  ]);

  propagatedBuildInputs = [
    blis
    catalogue
    cymem
    murmurhash
    numpy
    plac
    preshed
    srsly
    tqdm
    pydantic
    wasabi
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  checkInputs = [
    hypothesis
    mock
    pytest
  ];

  # Cannot find cython modules.
  doCheck = false;

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "blis>=0.4.0,<0.8.0" "blis>=0.4.0,<1.0" \
      --replace "pydantic>=1.7.4,!=1.8,!=1.8.1,<1.9.0" "pydantic<1.9.0"
  '';

  checkPhase = ''
    pytest thinc/tests
  '';

  pythonImportsCheck = [ "thinc" ];

  meta = with lib; {
    description = "Practical Machine Learning for NLP in Python";
    homepage = "https://github.com/explosion/thinc";
    license = licenses.mit;
    maintainers = with maintainers; [ aborsu ];
  };
}
