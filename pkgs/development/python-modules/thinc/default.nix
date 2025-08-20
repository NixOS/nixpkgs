{
  lib,
  stdenv,
  Accelerate,
  blis,
  buildPythonPackage,
  catalogue,
  confection,
  CoreFoundation,
  CoreGraphics,
  CoreVideo,
  cymem,
  cython_0,
  fetchPypi,
  hypothesis,
  mock,
  murmurhash,
  numpy,
  preshed,
  pydantic,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  srsly,
  typing-extensions,
  wasabi,
}:

buildPythonPackage rec {
  pname = "thinc";
  version = "8.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6zvtVPXADsmt2qogjFHM+gWUg9cxQM1RWqMzc3Fcblk=";
  };

  postPatch = ''
    # As per https://github.com/explosion/thinc/releases/tag/release-v8.3.0 no
    # code changes were required for NumPy 2.0. Thus Thinc should be compatible
    # with NumPy 1.0 and 2.0.
    substituteInPlace pyproject.toml setup.cfg \
      --replace-fail "numpy>=2.0.0,<2.1.0" numpy
    substituteInPlace setup.cfg \
      --replace-fail "numpy>=2.0.1,<2.1.0" numpy
  '';

  build-system = [
    blis
    cymem
    cython_0
    murmurhash
    numpy
    preshed
    setuptools
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    Accelerate
    CoreFoundation
    CoreGraphics
    CoreVideo
  ];

  dependencies = [
    blis
    catalogue
    confection
    cymem
    murmurhash
    numpy
    preshed
    pydantic
    srsly
    wasabi
  ] ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  nativeCheckInputs = [
    hypothesis
    mock
    pytestCheckHook
  ];

  preCheck = ''
    # avoid local paths, relative imports wont resolve correctly
    mv thinc/tests tests
    rm -r thinc
  '';

  pythonImportsCheck = [ "thinc" ];

  meta = with lib; {
    description = "Library for NLP machine learning";
    homepage = "https://github.com/explosion/thinc";
    changelog = "https://github.com/explosion/thinc/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ aborsu ];
  };
}
