{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  sqlalchemy,
  wtforms,
}:

buildPythonPackage rec {
  pname = "wtforms-sqlalchemy";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wtforms";
    repo = "wtforms-sqlalchemy";
    tag = version;
    hash = "sha256-E2F8lOcgne2yGEyn6g8j3mHr045eOyKu77DFGwWTPkc=";
  };

  build-system = [
    hatchling
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
    changelog = "https://github.com/wtforms/wtforms-sqlalchemy/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
