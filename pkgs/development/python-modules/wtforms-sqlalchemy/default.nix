{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonPackage rec {
  pname = "wtforms-sqlalchemy";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wtforms";
    repo = "wtforms-sqlalchemy";
    rev = version;
    hash = "sha256-x5fDfdf5BoclShrejNYI9Jt7LZiB9Sm5G3hmWvkWdoY=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = [
    python3.pkgs.sqlalchemy
    python3.pkgs.wtforms
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
