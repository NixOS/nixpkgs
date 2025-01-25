{
  lib,
  aiosqlite,
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
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "absent1706";
    repo = "sqlalchemy-mixins";
    tag = "v${version}";
    hash = "sha256-0uB3x7RQSNEq3DyTSiOIGajwPQQEBjXK8HOyuXCNa/E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    six
    sqlalchemy
  ];

  nativeCheckInputs = [
    aiosqlite
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sqlalchemy_mixins" ];

  meta = with lib; {
    description = "Python mixins for SQLAlchemy ORM";
    homepage = "https://github.com/absent1706/sqlalchemy-mixins";
    changelog = "https://github.com/absent1706/sqlalchemy-mixins/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
