{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
  more-itertools,
  prettytable,
  sqlglot,
  typing-extensions,

  # optional-dependencies
  # bigquery
  google-cloud-bigquery,
  google-cloud-bigquery-storage,
  # duckdb
  duckdb,
  pandas,
  # openai
  openai,
  # postgres
  psycopg2,
  # spark
  pyspark,
  # databricks-sql-connector
  databricks-sql-connector,

  # tests
  findspark,
  pytest-forked,
  pytest-postgresql,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sqlframe";
<<<<<<< HEAD
  version = "3.43.8";
=======
  version = "3.43.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eakmanrq";
    repo = "sqlframe";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-gsWA3aBolsR2zPwseHnQXSJRngXUHFGvi55UPevgUHw=";
=======
    hash = "sha256-qrKNn13wFEqvMQYzHH8T1pga1EUaVIt701p0k4eXw9c=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    more-itertools
    prettytable
    sqlglot
    typing-extensions
  ];

  optional-dependencies = {
    bigquery = [
      google-cloud-bigquery
      google-cloud-bigquery-storage
    ]
    ++ google-cloud-bigquery.optional-dependencies.pandas;
    duckdb = [
      duckdb
      pandas
    ];
    openai = [ openai ];
    pandas = [ pandas ];
    postgres = [ psycopg2 ];
    spark = [ pyspark ];
    databricks = [ databricks-sql-connector ];
  };

  pythonImportsCheck = [ "sqlframe" ];

  nativeCheckInputs = [
    findspark
    pytest-forked
    pytest-postgresql
    pytest-xdist
    pytestCheckHook
  ]
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (builtins.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  disabledTests = [
    # Requires google-cloud credentials
    # google.auth.exceptions.DefaultCredentialsErro
    "test_activate_bigquery_default_dataset"
    # AttributeError: module 'sqlglot.expressions' has no attribute 'Acos'
    "test_unquoted_identifiers"
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
