{ lib, fetchPypi, buildPythonPackage
, six, sqlalchemy
, mock, pytz, isort, flake8, jinja2, pg8000, pyodbc, pytest, pymysql, python-dateutil
, docutils, flexmock, psycopg2, pygments }:

buildPythonPackage rec {
  pname = "sqlalchemy-utils";
  version = "0.38.2";

  src = fetchPypi {
    inherit version;
    pname = "SQLAlchemy-Utils";
    sha256 = "9e01d6d3fb52d3926fcd4ea4a13f3540701b751aced0316bff78264402c2ceb4";
  };

  propagatedBuildInputs = [
    six
    sqlalchemy
  ];

  # Attempts to access localhost and there's also no database access
  doCheck = false;
  checkInputs = [
    mock
    pytz
    isort
    flake8
    jinja2
    pg8000
    pyodbc
    pytest
    pymysql
    python-dateutil
    docutils
    flexmock
    psycopg2
    pygments
  ];

  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    homepage = "https://github.com/kvesteri/sqlalchemy-utils";
    description = "Various utility functions and datatypes for SQLAlchemy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ eadwu ];
  };
}
