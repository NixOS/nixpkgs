{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  greenlet,

  # optionals
  cx-oracle,
  mysqlclient,
  pg8000,
  psycopg2,
  psycopg2cffi,
  # TODO: pymssql
  pymysql,
  pyodbc,

  # tests
  mock,
  pytest-xdist,
}:

buildPythonPackage (finalAttrs: {
  pname = "sqlalchemy";
  version = "1.3.23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sqlalchemy";
    repo = "sqlalchemy";
    tag = "rel_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-hWA0/f7rQpEfYTg10i0rBK3qeJbw3p6HW7S59rLnD0Q=";
  };

  postPatch = ''
    sed -i '/tag_build = dev/d' setup.cfg
  '';

  build-system = [ setuptools ];

  dependencies = [ greenlet ];

  optional-dependencies = lib.fix (self: {
    mssql = [ pyodbc ];
    mssql_pymysql = [
      # TODO: pymssql
    ];
    mssql_pyodbc = [ pyodbc ];
    mysql = [ mysqlclient ];
    oracle = [ cx-oracle ];
    postgresql = [ psycopg2 ];
    postgresql_pg8000 = [ pg8000 ];
    postgresql_psycopg2binary = [ psycopg2 ];
    postgresql_psycopg2cffi = [ psycopg2cffi ];
    pymysql = [ pymysql ];
  });

  nativeCheckInputs = [
    pytest-xdist
    mock
  ];

  disabledTestPaths = [
    # slow and high memory usage, not interesting
    "test/aaa_profiling"
  ];

  pythonImportsCheck = [ "sqlalchemy" ];

  meta = {
    changelog =
      let
        shortVersion = lib.replaceString "." "" (lib.versions.majorMinor finalAttrs.version);
      in
      "https://github.com/sqlalchemy/sqlalchemy/blob/${finalAttrs.src.rev}/doc/build/changelog/changelog_${shortVersion}.rst";
    description = "Database Toolkit for Python";
    homepage = "https://github.com/sqlalchemy/sqlalchemy";
    license = lib.licenses.mit;
  };
})
