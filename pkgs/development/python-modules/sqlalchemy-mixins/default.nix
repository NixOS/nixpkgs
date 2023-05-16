{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, pytestCheckHook
, pythonOlder
, six
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "sqlalchemy-mixins";
<<<<<<< HEAD
  version = "2.0.5";
=======
  version = "2.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "absent1706";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-iJrRlV/M0Z1IOdrwWSblefm6wjvdk4/v0am+It8VeWI=";
=======
    hash = "sha256-Ftpw3oDVu7Vdcwj7+a1G9cPeVUAEPggtozlvWioENIA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    six
    sqlalchemy
  ];

  nativeCheckInputs = [
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sqlalchemy_mixins"
  ];

  meta = with lib; {
    description = "Python mixins for SQLAlchemy ORM";
    homepage = "https://github.com/absent1706/sqlalchemy-mixins";
    changelog = "https://github.com/absent1706/sqlalchemy-mixins/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
