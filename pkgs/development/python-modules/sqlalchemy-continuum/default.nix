{ lib
, buildPythonPackage
, fetchPypi
, flask
, flask-login
, flask-sqlalchemy
, flexmock
, psycopg2
, pymysql
, pytestCheckHook
, pythonOlder
, sqlalchemy
, sqlalchemy-i18n
, sqlalchemy-utils
}:

buildPythonPackage rec {
  pname = "sqlalchemy-continuum";
  version = "1.3.14";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "SQLAlchemy-Continuum";
    inherit version;
    hash = "sha256-1+k/lx6R8tW9gM3M2kqaVEwpmx8cMhDXeqCjyd8O2hM=";
  };

  propagatedBuildInputs = [
    sqlalchemy
    sqlalchemy-utils
  ];

  passthru.optional-dependencies = {
    flask = [
      flask
    ];
    flask-login = [
      flask-login
    ];
    flask-sqlalchemy = [
      flask-sqlalchemy
    ];
    flexmock = [
      flexmock
    ];
    i18n = [
      sqlalchemy-i18n
    ];
  };

  checkInputs = [
    psycopg2
    pymysql
    pytestCheckHook
  ] ++ passthru.optional-dependencies.flask
  ++ passthru.optional-dependencies.flask-login
  ++ passthru.optional-dependencies.flask-sqlalchemy
  ++ passthru.optional-dependencies.flexmock
  ++ passthru.optional-dependencies.i18n;

  # indicate tests that we don't have a database server at hand
  DB = "sqlite";

  pythonImportsCheck = [
    "sqlalchemy_continuum"
  ];

  meta = with lib; {
    description = "Versioning and auditing extension for SQLAlchemy";
    homepage = "https://github.com/kvesteri/sqlalchemy-continuum/";
    changelog = "https://github.com/kvesteri/sqlalchemy-continuum/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
