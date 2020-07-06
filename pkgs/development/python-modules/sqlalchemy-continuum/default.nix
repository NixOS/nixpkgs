{ stdenv
, lib
, fetchPypi
, buildPythonPackage
, flask
, flask_login
, flask_sqlalchemy
, flexmock
, pytestCheckHook
, sqlalchemy
, sqlalchemy-utils
, sqlalchemy-i18n
}:

buildPythonPackage rec {
  pname = "SQLAlchemy-Continuum";
  version = "1.3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b7q0rqy5q7m9yw7yl7jzrk8p1jh1hqmqvzf45rwmwxs724kfkjg";
  };

  propagatedBuildInputs = [
    sqlalchemy
    sqlalchemy-utils
  ];

  # indicate tests that we don't have a database server at hand
  DB = "sqlite";

  checkInputs = [
    pytestCheckHook
    sqlalchemy-i18n
    flask
    flask_login
    flask_sqlalchemy
    flexmock
  ];

  meta = with lib; {
    homepage = "https://github.com/kvesteri/sqlalchemy-continuum/";
    description = "Versioning and auditing extension for SQLAlchemy";
    license = licenses.bsd3;
  };
}
