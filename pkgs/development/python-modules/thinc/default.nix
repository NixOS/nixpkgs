{
  lib,
  blas,
  blis,
  buildPythonPackage,
  catalogue,
  confection,
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
  setuptools,
  srsly,
  wasabi,
}:

buildPythonPackage rec {
  pname = "thinc";
  version = "9.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IfrimG13d6bwULkEbcnqsRhS8cmpl9zJAy8+zCJ4Sko=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml setup.cfg \
      --replace-fail "blis>=1.0.0,<1.1.0" blis
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

  buildInputs = [
    blas
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
  ];

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

  meta = {
    description = "Library for NLP machine learning";
    homepage = "https://github.com/explosion/thinc";
    changelog = "https://github.com/explosion/thinc/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aborsu ];
  };
}
