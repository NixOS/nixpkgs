{ lib
, stdenv
, buildPythonPackage
, python
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
  version = "8.0.14";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3MC8ao6BTiDyaCXj/X+DNCTpMYcTWVJFSl0X+sCc5J0=";
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
    description = "Practical Machine Learning for NLP in Python";
    homepage = "https://github.com/explosion/thinc";
    license = licenses.mit;
    maintainers = with maintainers; [ aborsu ];
  };
}
