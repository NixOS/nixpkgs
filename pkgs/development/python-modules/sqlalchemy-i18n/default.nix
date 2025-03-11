{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  sqlalchemy,
  sqlalchemy-utils,
  six,
  postgresql,
  postgresqlTestHook,
  psycopg2,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sqlalchemy-i18n";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "SQLAlchemy-i18n";
    inherit version;
    hash = "sha256-3jM3ZIOlgcoUIY2PV6EURmxfcrZ0qVg5tsRWSm5neW8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    sqlalchemy
    sqlalchemy-utils
    six
  ];

  pythonImportsCheck = [ "sqlalchemy_i18n" ];

  nativeCheckInputs = [
    postgresql
    postgresqlTestHook
    psycopg2
    pytestCheckHook
  ];

  env = {
    PGDATABASE = "sqlalchemy_i18n_test";
    postgresqlEnableTCP = 1;
  };

  meta = {
    homepage = "https://github.com/kvesteri/sqlalchemy-i18n";
    description = "Internationalization extension for SQLAlchemy models";
    license = lib.licenses.bsd3;
    # sqlalchemy.exc.InvalidRequestError: The 'sqlalchemy.orm.mapper()' function is removed as of SQLAlchemy 2.0.
    broken = lib.versionAtLeast sqlalchemy.version "2";
  };
}
