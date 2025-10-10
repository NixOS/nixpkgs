{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
  prettytable,
  sqlglot,
  typing-extensions,

  # tests
  databricks-sql-connector,
  duckdb,
  findspark,
  google-cloud-bigquery,
  pyspark,
  pytest-postgresql,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sqlframe";
  version = "3.38.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eakmanrq";
    repo = "sqlframe";
    tag = "v${version}";
    hash = "sha256-ekDt9vsHdHhUNaQghG3EaM82FRZYdw+gaxENcurSayk=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    prettytable
    sqlglot
    typing-extensions
  ];

  pythonImportsCheck = [ "sqlframe" ];

  nativeCheckInputs = [
    databricks-sql-connector
    duckdb
    findspark
    google-cloud-bigquery
    pyspark
    pytest-postgresql
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = [
    # Requires google-cloud credentials
    # google.auth.exceptions.DefaultCredentialsErro
    "test_activate_bigquery_default_dataset"
  ];

  disabledTestPaths = [
    # duckdb.duckdb.CatalogException: Catalog Error: Table Function with name "dsdgen" is not in the catalog, but it exists in the tpcds extension.
    # "tests/integration/test_int_dataframe.py"
    "tests/integration/"
  ];

  meta = {
    description = "Turning PySpark Into a Universal DataFrame API";
    homepage = "https://github.com/eakmanrq/sqlframe";
    changelog = "https://github.com/eakmanrq/sqlframe/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
