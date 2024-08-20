{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
  six,
  sqlalchemy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sqlalchemy-mixins";
  version = "2.0.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "absent1706";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-iJrRlV/M0Z1IOdrwWSblefm6wjvdk4/v0am+It8VeWI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    six
    sqlalchemy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sqlalchemy_mixins" ];

  meta = with lib; {
    description = "Python mixins for SQLAlchemy ORM";
    homepage = "https://github.com/absent1706/sqlalchemy-mixins";
    changelog = "https://github.com/absent1706/sqlalchemy-mixins/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
