{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, blis
, catalogue
, cymem
, cython
, Accelerate
, CoreFoundation
, CoreGraphics
, CoreVideo
, hypothesis
, mock
, murmurhash
, numpy
, pathlib
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
  version = "8.0.10";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-teTbjSTmvopfHkoXhUdyt5orVgIkUZ9Qoh85UcokAB8=";
  };

  buildInputs = [ cython ]
    ++ lib.optionals stdenv.isDarwin [
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
  ] ++ lib.optional (pythonOlder "3.8") typing-extensions;

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

  pythonImportsCheck = [ "thinc" ];

  meta = with lib; {
    description = "Practical Machine Learning for NLP in Python";
    homepage = "https://github.com/explosion/thinc";
    license = licenses.mit;
    maintainers = with maintainers; [ aborsu ];
  };
}
