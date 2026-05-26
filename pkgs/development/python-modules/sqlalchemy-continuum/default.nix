{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  flask,
  flask-login,
  flask-sqlalchemy,
  packaging,
  psycopg2,
  pymysql,
  pytestCheckHook,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "sqlalchemy-continuum";
  version = "1.5.2";
  pyproject = true;

  src = fetchPypi {
    pname = "sqlalchemy_continuum";
    inherit version;
    hash = "sha256-JXHW62FWvIVir7OS/d3rS7MeRKH9HzeIy2Je/i9pbGM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    sqlalchemy
  ];

  optional-dependencies = {
    flask = [ flask ];
    flask-login = [ flask-login ];
    flask-sqlalchemy = [ flask-sqlalchemy ];
  };

  nativeCheckInputs = [
    packaging
    psycopg2
    pymysql
    pytestCheckHook
  ]
  ++ optional-dependencies.flask
  ++ optional-dependencies.flask-login
  ++ optional-dependencies.flask-sqlalchemy;

  preCheck = ''
    # Indicate tests that we don't have a database server at hand
    export DB=sqlite
  '';

  pythonImportsCheck = [ "sqlalchemy_continuum" ];

  meta = {
    description = "Versioning and auditing extension for SQLAlchemy";
    homepage = "https://github.com/kvesteri/sqlalchemy-continuum/";
    changelog = "https://github.com/kvesteri/sqlalchemy-continuum/blob/${version}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
