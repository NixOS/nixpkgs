{ lib
, fetchPypi
, buildPythonPackage
, flask
, flask-login
, flask-sqlalchemy
, flexmock
, pytestCheckHook
, sqlalchemy
, sqlalchemy-utils
, sqlalchemy-i18n
}:

buildPythonPackage rec {
  pname = "SQLAlchemy-Continuum";
  version = "1.3.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-JTqlHQmaVH2qKz7CFyCqpous3ecOpoFrxVlzasbc21I=";
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
    flask-login
    flask-sqlalchemy
    flexmock
  ];

  meta = with lib; {
    homepage = "https://github.com/kvesteri/sqlalchemy-continuum/";
    description = "Versioning and auditing extension for SQLAlchemy";
    license = licenses.bsd3;
  };
}
