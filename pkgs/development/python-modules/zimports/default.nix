{ lib
<<<<<<< HEAD
=======
, isPy3k
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
, buildPythonPackage
, flake8-import-order
, pyflakes
, tomli
, setuptools
, pytestCheckHook
<<<<<<< HEAD
, pythonAtLeast
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
}:

buildPythonPackage rec {
  pname = "zimports";
<<<<<<< HEAD
  version = "0.6.1";
  format = "setuptools";

  # upstream technically support 3.7 through 3.9, but 3.10 happens to work while 3.11 breaks with an import error
  disabled = pythonOlder "3.7" || pythonAtLeast "3.11";
=======
  version = "0.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sqlalchemyorg";
    repo = "zimports";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-+sDvl8z0O0cZyS1oZgt924hlOkYeHiStpXL9y9+JZ5I=";
=======
    hash = "sha256-qm5mA8pCSLbkupGBo+ppHSW6uy1j/FfV3idvGQGhjqU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    flake8-import-order
    pyflakes
    setuptools
    tomli
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "zimports"
  ];

  meta = with lib; {
    description = "Python import rewriter";
    homepage = "https://github.com/sqlalchemyorg/zimports";
    license = licenses.mit;
    maintainers = with maintainers; [ timokau ];
  };
}
