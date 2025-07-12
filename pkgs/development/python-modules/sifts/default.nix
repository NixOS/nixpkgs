{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  setuptools-scm,

  numpy,
  psycopg2,
  sqlalchemy,

  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sifts";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DavidMStraub";
    repo = "sifts";
    rev = "v${version}";
    hash = "sha256-n1lPV9EqibrYjwC7IOQ8lYcNLLfQLmMvZteIJ2fcKVs=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    psycopg2
    sqlalchemy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    "tests/sifts/test_postgres.py" # requires pytest-docker
  ];

  pythonImportsCheck = [
    "sifts"
  ];

  meta = {
    description = "Simple full-text & vector search library with SQL backend";
    homepage = "https://github.com/DavidMStraub/sifts";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
