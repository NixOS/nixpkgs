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
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DavidMStraub";
    repo = "sifts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mh2lkiKiyQTvDnMJeIwicLN0BEE9UBfPiw6rXuMNwZw=";
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
