{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, python-dateutil
, duckdb
, pyspark
}:
buildPythonPackage rec {
  pname = "sqlglot";
  version = "10.5.2";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    repo = "sqlglot";
    owner = "tobymao";
    rev = "v${version}";
    hash = "sha256-ZFc2aOhCTRFlrzgnYDSdIZxRqKZ8FvkYSZRU0OMHI34=";
  };

  propagatedBuildInputs = [ python-dateutil ];

  nativeCheckInputs = [ pytestCheckHook duckdb pyspark ];

  # these integration tests assume a running Spark instance
  disabledTestPaths = [ "tests/dataframe/integration" ];

  pythonImportsCheck = [ "sqlglot" ];

  meta = with lib; {
    description = "A no dependency Python SQL parser, transpiler, and optimizer";
    homepage = "https://github.com/tobymao/sqlglot";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
