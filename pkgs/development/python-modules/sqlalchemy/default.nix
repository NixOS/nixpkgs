{ stdenv
, lib
, isPyPy
, pythonOlder
, fetchPypi
, buildPythonPackage

# build
, cython

# propagates
, greenlet
, importlib-metadata
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
# TODO: oracledb
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
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "SQLAlchemy";
  version = "1.4.41"; # TODO: check python3Packages.fastapi when updating to >= 1.4.42
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ApL3DReX48VOhi5vMK5HQBRki8nHI+FKL9pzCtsKl5E=";
  };

  nativeBuildInputs = lib.optionals (!isPyPy) [
    cython
  ];

  propagatedBuildInputs = [
    greenlet
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  passthru.optional-dependencies = rec {
    asyncio = [
      greenlet
    ];
    mypy = [
      #mypy
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
      # TODO: oracledb
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

  checkInputs = [
    pytestCheckHook
    mock
  ];

  # disable mem-usage tests on mac, has trouble serializing pickle files
  disabledTests = lib.optionals stdenv.isDarwin [
    "MemUsageWBackendTest"
    "MemUsageTest"
  ];

  meta = with lib; {
    changelog = "https://github.com/sqlalchemy/sqlalchemy/releases/tag/rel_${builtins.replaceStrings [ "." ] [ "_" ] version}";
    description = "The Python SQL toolkit and Object Relational Mapper";
    homepage = "http://www.sqlalchemy.org/";
    license = licenses.mit;
  };
}
