{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  flask,
  flask-login,
  flask-sqlalchemy,
  psycopg2,
  pymysql,
  pytestCheckHook,
  pythonOlder,
  sqlalchemy,
  sqlalchemy-i18n,
  sqlalchemy-utils,
}:

buildPythonPackage rec {
  pname = "sqlalchemy-continuum";
  version = "1.4.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "sqlalchemy_continuum";
    inherit version;
    hash = "sha256-D9K+efcY7aR8IgaHnZLsTr8YiTZGN7PK8+5dNL0ZyOM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    sqlalchemy
    sqlalchemy-utils
  ];

  optional-dependencies = {
    flask = [ flask ];
    flask-login = [ flask-login ];
    flask-sqlalchemy = [ flask-sqlalchemy ];
    i18n = [ sqlalchemy-i18n ];
  };

  nativeCheckInputs = [
    psycopg2
    pymysql
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  preCheck = ''
    # Indicate tests that we don't have a database server at hand
    export DB=sqlite
  '';

  pythonImportsCheck = [ "sqlalchemy_continuum" ];

  meta = with lib; {
    description = "Versioning and auditing extension for SQLAlchemy";
    homepage = "https://github.com/kvesteri/sqlalchemy-continuum/";
    changelog = "https://github.com/kvesteri/sqlalchemy-continuum/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
