{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nose,
  pytestCheckHook,
  pythonOlder,
  six,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "sqlalchemy-mixins";
  version = "2.0.5";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "absent1706";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-iJrRlV/M0Z1IOdrwWSblefm6wjvdk4/v0am+It8VeWI=";
  };

  propagatedBuildInputs = [
    six
    sqlalchemy
  ];

  nativeCheckInputs = [
    nose
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
