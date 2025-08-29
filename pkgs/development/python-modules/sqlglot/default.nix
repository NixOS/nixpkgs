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
  version = "27.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "sqlglot";
    owner = "tobymao";
    tag = "v${version}";
    hash = "sha256-/+hrbyAQJHbKzjaBr9ssuXuKpbCSWAarLa5oX5NqfOc=";
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
