{ lib
, stdenv
, Accelerate
, blis
, buildPythonPackage
, catalogue
, confection
, contextvars
, CoreFoundation
, CoreGraphics
, CoreVideo
, cymem
, cython
, dataclasses
, fetchPypi
, hypothesis
, mock
, murmurhash
, numpy
, plac
, preshed
, pydantic
, pytestCheckHook
, python
, pythonOlder
, srsly
, tqdm
, typing-extensions
, wasabi
}:

buildPythonPackage rec {
  pname = "thinc";
  version = "8.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-m5AoKYTzy6rJjgNn3xsa+eSDYjG8Bj361yQqnQ3VK80=";
  };

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
    confection
    cymem
    murmurhash
    numpy
    plac
    preshed
    pydantic
    srsly
    tqdm
    wasabi
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.7") [
    contextvars
    dataclasses
  ];

  checkInputs = [
    hypothesis
    mock
    pytestCheckHook
  ];

  # Add native extensions.
  preCheck = ''
    export PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH

    # avoid local paths, relative imports wont resolve correctly
    mv thinc/tests tests
    rm -r thinc
  '';

  pythonImportsCheck = [
    "thinc"
  ];

  meta = with lib; {
    description = "Library for NLP machine learning";
    homepage = "https://github.com/explosion/thinc";
    license = licenses.mit;
    maintainers = with maintainers; [ aborsu ];
  };
}
