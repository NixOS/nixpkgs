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
  numpy,
  pandas,
}:

buildPythonPackage rec {
  pname = "sqlglot";
  version = "28.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "sqlglot";
    owner = "tobymao";
    tag = "v${version}";
    hash = "sha256-1RAjGqu2D/wrec/sryPGZlPnaBGkyhYpzdaZu9KYh2Q=";
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
    numpy
    pandas
  ];

  pythonImportsCheck = [ "sqlglot" ];

  meta = {
    description = "No dependency Python SQL parser, transpiler, and optimizer";
    homepage = "https://github.com/tobymao/sqlglot";
    changelog = "https://github.com/tobymao/sqlglot/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
  };
}
