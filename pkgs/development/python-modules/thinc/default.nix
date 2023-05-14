{ lib
, stdenv
, Accelerate
, blis
, buildPythonPackage
, catalogue
, confection
, CoreFoundation
, CoreGraphics
, CoreVideo
, cymem
, cython
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
  version = "8.1.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NcZXy+2wT8W8JHhl1mWSHOw9Ve81+/zj7hogSGtyBoM=";
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
  ];

  nativeCheckInputs = [
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
