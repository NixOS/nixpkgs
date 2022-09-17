{ lib
, fetchPypi
, buildPythonPackage
, flask
, flask_login
, flask-sqlalchemy
, flexmock
, pytestCheckHook
, sqlalchemy
, sqlalchemy-utils
, sqlalchemy-i18n
}:

buildPythonPackage rec {
  pname = "SQLAlchemy-Continuum";
  version = "1.3.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "rlHl59MAQhsicMtZQT9rv1iQrDyVYJlawtyhvFaAM7o=";
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
    flask-sqlalchemy
    flexmock
  ];

  meta = with lib; {
    homepage = "https://github.com/kvesteri/sqlalchemy-continuum/";
    description = "Versioning and auditing extension for SQLAlchemy";
    license = licenses.bsd3;
  };
}
