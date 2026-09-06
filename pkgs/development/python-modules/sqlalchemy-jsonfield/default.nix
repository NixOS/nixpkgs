{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  sqlalchemy,
  setuptools-scm,
  setuptools,
  pytestCheckHook,
  pytest-sugar,
  pymysql,
  psycopg2,
}:

buildPythonPackage (finalAttrs: {
  pname = "sqlalchemy-jsonfield";
  version = "1.0.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "penguinolog";
    repo = "sqlalchemy_jsonfield";
    tag = finalAttrs.version;
    hash = "sha256-4zLXB3UQh6pgQ80KrxkLeC5yiv1R8t2+JmSukmGXr7I=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    sqlalchemy
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-sugar
    pymysql
    psycopg2
  ];

  pythonImportsCheck = [ "sqlalchemy_jsonfield" ];

  meta = {
    description = "SQLALchemy JSONField implementation for storing dicts at SQL independently from JSON type support";
    homepage = "https://github.com/penguinolog/sqlalchemy_jsonfield";
    changelog = "https://github.com/penguinolog/sqlalchemy_jsonfield/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
