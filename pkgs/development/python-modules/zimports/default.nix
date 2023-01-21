{ lib
, isPy3k
, fetchFromGitHub
, buildPythonPackage
, flake8-import-order
, pyflakes
, tomli
, setuptools
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "zimports";
  version = "0.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sqlalchemyorg";
    repo = "zimports";
    rev = "refs/tags/v${version}";
    hash = "sha256-qm5mA8pCSLbkupGBo+ppHSW6uy1j/FfV3idvGQGhjqU=";
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
