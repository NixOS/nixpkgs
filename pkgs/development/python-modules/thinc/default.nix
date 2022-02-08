{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, blis
, catalogue
, cymem
, cython
, contextvars
, dataclasses
, Accelerate
, CoreFoundation
, CoreGraphics
, CoreVideo
, hypothesis
, mock
, murmurhash
, numpy
, plac
, pythonOlder
, preshed
, pydantic
, srsly
, tqdm
, typing-extensions
, wasabi
}:

buildPythonPackage rec {
  pname = "thinc";
  version = "8.0.13";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-R2YqOuM9RFp3tup7dyREgFx7uomR8SLjUNr3Le3IFxo=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pydantic>=1.7.4,!=1.8,!=1.8.1,<1.9.0" "pydantic"
  '';

  buildInputs = [
    cython
  ] ++ lib.optionals stdenv.isDarwin [
    Accelerate
    CoreFoundation
    CoreGraphics
    CoreVideo
  ];

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
  ] ++ lib.optional (pythonOlder "3.8") [
    typing-extensions
  ] ++ lib.optional (pythonOlder "3.7") [
    contextvars
    dataclasses
  ];

  checkInputs = [
    hypothesis
    mock
    pytestCheckHook
  ];

  # Cannot find cython modules.
  doCheck = false;

  pytestFlagsArray = [
    "thinc/tests"
  ];

  pythonImportsCheck = [
    "thinc"
  ];

  meta = with lib; {
    description = "Practical Machine Learning for NLP in Python";
    homepage = "https://github.com/explosion/thinc";
    license = licenses.mit;
    maintainers = with maintainers; [ aborsu ];
  };
}
