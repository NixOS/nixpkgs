{
  lib,
  python3,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  sqlalchemy,
  wtforms,
}:

python3.pkgs.buildPythonPackage rec {
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

  meta = with lib; {
    description = "WTForms integration for SQLAlchemy";
    homepage = "https://github.com/wtforms/wtforms-sqlalchemy";
    changelog = "https://github.com/wtforms/wtforms-sqlalchemy/blob/${src.rev}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
