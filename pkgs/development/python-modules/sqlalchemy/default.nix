{
  lib,
  isPyPy,
  pythonOlder,
  fetchFromGitHub,
  buildPythonPackage,

  # build
  cython,
  setuptools,

  # propagates
  greenlet,
  typing-extensions,

  # optionals
  aiomysql,
  aiosqlite,
  asyncmy,
  asyncpg,
  cx-oracle,
  mariadb,
  mypy,
  mysql-connector,
  mysqlclient,
  oracledb,
  pg8000,
  psycopg,
  psycopg2,
  psycopg2cffi,
  # TODO: pymssql
  pymysql,
  pyodbc,
  # TODO: sqlcipher3

  # tests
  mock,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sqlalchemy";
  version = "2.0.30";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sqlalchemy";
    repo = "sqlalchemy";
    rev = "refs/tags/rel_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-l6VxBK4RT/sAFkz3g633MrfQH9Bvp/JE12mdtqjsxd8=";
  };

  postPatch = ''
    sed -i '/tag_build = dev/d' setup.cfg
  '';

  nativeBuildInputs = [ setuptools ] ++ lib.optionals (!isPyPy) [ cython ];

  propagatedBuildInputs = [
    greenlet
    typing-extensions
  ];

  passthru.optional-dependencies = lib.fix (self: {
    asyncio = [ greenlet ];
    mypy = [ mypy ];
    mssql = [ pyodbc ];
    mssql_pymysql = [
      # TODO: pymssql
    ];
    mssql_pyodbc = [ pyodbc ];
    mysql = [ mysqlclient ];
    mysql_connector = [ mysql-connector ];
    mariadb_connector = [ mariadb ];
    oracle = [ cx-oracle ];
    oracle_oracledb = [ oracledb ];
    postgresql = [ psycopg2 ];
    postgresql_pg8000 = [ pg8000 ];
    postgresql_asyncpg = [ asyncpg ] ++ self.asyncio;
    postgresql_psycopg2binary = [ psycopg2 ];
    postgresql_psycopg2cffi = [ psycopg2cffi ];
    postgresql_psycopg = [ psycopg ];
    postgresql_psycopgbinary = [ psycopg ];
    pymysql = [ pymysql ];
    aiomysql = [ aiomysql ] ++ self.asyncio;
    asyncmy = [ asyncmy ] ++ self.asyncio;
    aiosqlite = [
      aiosqlite
      typing-extensions
    ] ++ self.asyncio;
    sqlcipher = [
      # TODO: sqlcipher3
    ];
  });

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
    mock
  ];

  disabledTestPaths = [
    # typing correctness, not interesting
    "test/ext/mypy"
    "test/typing"
    # slow and high memory usage, not interesting
    "test/aaa_profiling"
  ];

  meta = with lib; {
    changelog = "https://github.com/sqlalchemy/sqlalchemy/releases/tag/rel_${
      builtins.replaceStrings [ "." ] [ "_" ] version
    }";
    description = "Python SQL toolkit and Object Relational Mapper";
    homepage = "http://www.sqlalchemy.org/";
    license = licenses.mit;
  };
}
