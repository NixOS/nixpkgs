{ lib
, buildPythonPackage
, fetchPypi
, six
, sqlalchemy
, colour
, flexmock
, jinja2
, mock
, pg8000
, phonenumbers
, pygments
, pymysql
, pytestCheckHook
, python-dateutil
}:

buildPythonPackage rec {
  pname = "sqlalchemy-utils";
  version = "0.38.2";

  src = fetchPypi {
    inherit version;
    pname = "SQLAlchemy-Utils";
    sha256 = "9e01d6d3fb52d3926fcd4ea4a13f3540701b751aced0316bff78264402c2ceb4";
  };

  patches = [
    # We don't run MySQL, MSSQL, or PostgreSQL
    ./skip-database-tests.patch
  ];

  propagatedBuildInputs = [
    six
    sqlalchemy
  ];

  checkInputs = [
    colour
    flexmock
    jinja2
    mock
    pg8000
    phonenumbers
    pygments
    pymysql
    pytestCheckHook
    python-dateutil
  ];

  disabledTests = [
    "test_literal_bind"
  ];

  meta = with lib; {
    homepage = "https://github.com/kvesteri/sqlalchemy-utils";
    description = "Various utility functions and datatypes for SQLAlchemy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ eadwu ];
  };
}
