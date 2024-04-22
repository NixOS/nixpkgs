{ lib
, buildPythonPackage
, duckdb
, fetchFromGitHub
, pytestCheckHook
, python-dateutil
, pythonOlder
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "sqlglot";
  version = "23.11.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    repo = "sqlglot";
    owner = "tobymao";
    rev = "refs/tags/v${version}";
    hash = "sha256-A0Hj2uLdJXxMF/4VH16OxJzK0JuMBxT46g7PkiQWdpk=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    # Optional dependency used in the sqlglot optimizer
    python-dateutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
    duckdb
  ];

  disabledTestPaths = [
    # These integration tests assume a running Spark instance
    "tests/dataframe/integration"
  ];

  pythonImportsCheck = [
    "sqlglot"
  ];

  meta = with lib; {
    description = "A no dependency Python SQL parser, transpiler, and optimizer";
    homepage = "https://github.com/tobymao/sqlglot";
    changelog = "https://github.com/tobymao/sqlglot/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
