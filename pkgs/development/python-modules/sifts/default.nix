{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  psycopg2-binary,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
  sqlalchemy,
}:

buildPythonPackage (finalAttrs: {
  pname = "sifts";
  version = "1.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DavidMStraub";
    repo = "sifts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2wgKW77d0GWFlz4aGRBXtY0KXFOBR0IsGIstU/z/Tkg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    psycopg2-binary
    sqlalchemy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # requires Docker
    "tests/sifts/test_postgres.py"
  ];

  pythonImportsCheck = [ "sifts" ];

  meta = {
    description = "Simple full text and vector search engine Python library";
    homepage = "https://github.com/DavidMStraub/sifts";
    changelog = "https://github.com/DavidMStraub/sifts/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
})
