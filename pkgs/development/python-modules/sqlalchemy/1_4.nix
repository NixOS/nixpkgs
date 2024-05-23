{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  greenlet,

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
  pg8000,
  psycopg2,
  psycopg2cffi,
  # TODO: pymssql
  pymysql,
  pyodbc,
  # TODO: sqlcipher3
  typing-extensions,

  # tests
  mock,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sqlalchemy";
  version = "1.4.52";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sqlalchemy";
    repo = "sqlalchemy";
    rev = "rel_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-3JiPDOI6KDQwtBtISvHi3d+Rdm0pz1d9cnZu3+f4jYE=";
  };

  postPatch = ''
    sed -i '/tag_build = dev/d' setup.cfg
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ greenlet ];

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
    postgresql = [ psycopg2 ];
    postgresql_pg8000 = [ pg8000 ];
    postgresql_asyncpg = [ asyncpg ] ++ self.asyncio;
    postgresql_psycopg2binary = [ psycopg2 ];
    postgresql_psycopg2cffi = [ psycopg2cffi ];
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
    # slow and high memory usage, not interesting
    "test/aaa_profiling"
  ];

  pythonImportsCheck = [ "sqlalchemy" ];

  meta = with lib; {
    changelog = "https://github.com/sqlalchemy/sqlalchemy/releases/tag/rel_${
      builtins.replaceStrings [ "." ] [ "_" ] version
    }";
    description = "The Database Toolkit for Python";
    homepage = "https://github.com/sqlalchemy/sqlalchemy";
    license = licenses.mit;
  };
}
