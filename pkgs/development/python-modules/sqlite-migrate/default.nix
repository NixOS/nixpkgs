{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  sqlite-utils,
}:

buildPythonPackage rec {
  pname = "sqlite-migrate";
  version = "0.1b0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jVArPKS5xF5WASvTXAPSMjXwgjyXbUzpQMu0DjMIfe0=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ sqlite-utils ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sqlite_migrate" ];

  meta = with lib; {
    description = "Simple database migration system for SQLite, based on sqlite-utils";
    homepage = "https://github.com/simonw/sqlite-migrate";
    changelog = "https://github.com/simonw/sqlite-migrate/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ aldoborrero ];
  };
}
