{ stdenv
, lib
, isPyPy
, pythonOlder
, fetchPypi
, buildPythonPackage

# build
, cython
, setuptools

# propagates
, greenlet
, typing-extensions

# optionals
, aiosqlite
, asyncmy
, asyncpg
, cx_oracle
, mariadb
, mypy
, mysql-connector
, mysqlclient
, oracledb
, pg8000
, psycopg
, psycopg2
, psycopg2cffi
# TODO: pymssql
, pymysql
, pyodbc
# TODO: sqlcipher3

# tests
, mock
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "SQLAlchemy";
  version = "2.0.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-laGOGmryEU29nuTxaK0zBw1jF+Ebr6KNmDzHtYX+kAs=";
  };

  nativeBuildInputs =[
    setuptools
  ] ++ lib.optionals (!isPyPy) [
    cython
  ];

  propagatedBuildInputs = [
    greenlet
    typing-extensions
  ];

  passthru.optional-dependencies = rec {
    asyncio = [
      greenlet
    ];
    mypy = [
      mypy
    ];
    mssql = [
      pyodbc
    ];
    mssql_pymysql = [
      # TODO: pymssql
    ];
    mssql_pyodbc = [
      pyodbc
    ];
    mysql = [
      mysqlclient
    ];
    mysql_connector = [
      mysql-connector
    ];
    mariadb_connector = [
      mariadb
    ];
    oracle = [
      cx_oracle
    ];
    oracle_oracledb = [
      oracledb
    ];
    postgresql = [
      psycopg2
    ];
    postgresql_pg8000 = [
      pg8000
    ];
    postgresql_asyncpg = [
      asyncpg
    ] ++ asyncio;
    postgresql_psycopg2binary = [
      psycopg2
    ];
    postgresql_psycopg2cffi = [
      psycopg2cffi
    ];
    postgresql_psycopg = [
      psycopg
    ];
    pymysql = [
      pymysql
    ];
    aiomysql = [
      aiomysql
    ] ++ asyncio;
    asyncmy = [
      asyncmy
    ] ++ asyncio;
    aiosqlite = [
      aiosqlite
      typing-extensions
    ] ++ asyncio;
    sqlcipher = [
      # TODO: sqlcipher3
    ];
  };

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
    mock
  ];

  disabledTestPaths = [
    # typing correctness, not interesting
    "test/ext/mypy"
    # slow and high memory usage, not interesting
    "test/aaa_profiling"
  ];

  meta = with lib; {
    changelog = "https://github.com/sqlalchemy/sqlalchemy/releases/tag/rel_${builtins.replaceStrings [ "." ] [ "_" ] version}";
    description = "The Python SQL toolkit and Object Relational Mapper";
    homepage = "http://www.sqlalchemy.org/";
    license = licenses.mit;
  };
}
