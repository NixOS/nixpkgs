{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  python-dateutil,

  # tests
  pytestCheckHook,
  duckdb,
}:

buildPythonPackage rec {
  pname = "sqlglot";
  version = "26.16.2";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "sqlglot";
    owner = "tobymao";
    tag = "v${version}";
    hash = "sha256-uX72AHr4IC+u5AYkW/3myruVPs5NZ1V3THVg+9GWxpg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    # Optional dependency used in the sqlglot optimizer
    python-dateutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
    duckdb
  ];

  pythonImportsCheck = [ "sqlglot" ];

  meta = {
    description = "No dependency Python SQL parser, transpiler, and optimizer";
    homepage = "https://github.com/tobymao/sqlglot";
    changelog = "https://github.com/tobymao/sqlglot/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
  };
}
