{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  sqlalchemy,
  wtforms,
}:

buildPythonPackage rec {
  pname = "wtforms-sqlalchemy";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wtforms";
    repo = "wtforms-sqlalchemy";
    rev = version;
    hash = "sha256-uR09LYfcyre+AC2TTEIhpjSI7y4Yo0GJ20smkzo5PRY=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    sqlalchemy
    wtforms
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "wtforms_sqlalchemy" ];

  meta = {
    description = "WTForms integration for SQLAlchemy";
    homepage = "https://github.com/wtforms/wtforms-sqlalchemy";
    changelog = "https://github.com/wtforms/wtforms-sqlalchemy/blob/${version}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
