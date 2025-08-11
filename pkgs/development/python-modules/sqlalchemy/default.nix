{
  lib,
  isPyPy,
  pythonOlder,
  fetchFromGitHub,
  buildPythonPackage,
  nix-update-script,

  # build
  cython,
  setuptools,

  # propagates
  greenlet,
  typing-extensions,

  # optionals
  aiomysql,
  # TODO: aioodbc
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
  pymssql,
  pymysql,
  pyodbc,
  sqlcipher3,
  types-greenlet,

  # tests
  mock,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sqlalchemy";
  version = "2.0.43";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sqlalchemy";
    repo = "sqlalchemy";
    tag = "rel_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-yZIYcJ6gI1oUsQ/vRd5yz6Tgcl7ARpjxnjZNsfeXinM=";
  };

  postPatch = ''
    sed -i '/tag_build = dev/d' setup.cfg
  '';

  build-system = [ setuptools ] ++ lib.optionals (!isPyPy) [ cython ];

  dependencies = [
    greenlet
    typing-extensions
  ];

  optional-dependencies = lib.fix (self: {
    asyncio = [ greenlet ];
    mypy = [
      mypy
      types-greenlet
    ];
    mssql = [ pyodbc ];
    mssql_pymysql = [ pymssql ];
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
    # TODO: aioodbc
    asyncmy = [ asyncmy ] ++ self.asyncio;
    aiosqlite = [ aiosqlite ] ++ self.asyncio;
    sqlcipher = [ sqlcipher3 ];
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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^rel_([0-9]+)_([0-9]+)_([0-9]+)$"
    ];
  };

  meta = with lib; {
    changelog = "https://github.com/sqlalchemy/sqlalchemy/releases/tag/rel_${
      builtins.replaceStrings [ "." ] [ "_" ] version
    }";
    description = "Python SQL toolkit and Object Relational Mapper";
    homepage = "http://www.sqlalchemy.org/";
    license = licenses.mit;
  };
}
