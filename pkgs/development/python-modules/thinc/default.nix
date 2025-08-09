{
  lib,
  blas,
  blis,
  buildPythonPackage,
  catalogue,
  confection,
  cymem,
  cython,
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
  version = "8.3.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SZg/m33cQ0OpUyaUqRGN0hbXpgBSCiGEmkO2wmjsbK0=";
  };

  build-system = [
    blis
    cymem
    cython
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
