{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  wheel,
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

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    sqlalchemy
    wtforms
  ];

  pythonImportsCheck = [ "wtforms_sqlalchemy" ];

  meta = with lib; {
    description = "WTForms integration for SQLAlchemy";
    homepage = "https://github.com/wtforms/wtforms-sqlalchemy";
    changelog = "https://github.com/wtforms/wtforms-sqlalchemy/blob/${src.rev}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ thubrecht ];
    mainProgram = "wtforms-sqlalchemy";
  };
}
