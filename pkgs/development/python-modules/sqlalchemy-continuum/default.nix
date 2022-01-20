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
  version = "1.3.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ae51e5e7d300421b2270cb59413f6bbf5890ac3c9560995ac2dca1bc568033ba";
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
    # https://github.com/kvesteri/sqlalchemy-continuum/issues/255
    broken = lib.versionAtLeast sqlalchemy.version "1.4";
  };
}
