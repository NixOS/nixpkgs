{ lib
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
  version = "1.3.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c9yd9s98crqgs39rc2ld2r0nchgyjrfbjdlqb99y4hhc6lv04xw";
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
