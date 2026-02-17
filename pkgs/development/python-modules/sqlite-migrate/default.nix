{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
  sqlite-utils,
}:

buildPythonPackage rec {
  pname = "sqlite-migrate";
  version = "0.1b0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jVArPKS5xF5WASvTXAPSMjXwgjyXbUzpQMu0DjMIfe0=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ sqlite-utils ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sqlite_migrate" ];

  meta = {
    description = "Simple database migration system for SQLite, based on sqlite-utils";
    homepage = "https://github.com/simonw/sqlite-migrate";
    changelog = "https://github.com/simonw/sqlite-migrate/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aldoborrero ];
  };
}
