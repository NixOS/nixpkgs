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
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "sqlalchemy";
  version = "1.3.24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sqlalchemy";
    repo = "sqlalchemy";
    tag = "rel_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-6qAjyqMVrugABHssAQuql3z1YHTAOSm5hARJuJXJJvo=";
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

  meta = {
    changelog = "https://github.com/sqlalchemy/sqlalchemy/releases/tag/${finalAttrs.src.tag})";
    description = "Database Toolkit for Python";
    homepage = "https://github.com/sqlalchemy/sqlalchemy";
    license = lib.licenses.mit;
  };
})
