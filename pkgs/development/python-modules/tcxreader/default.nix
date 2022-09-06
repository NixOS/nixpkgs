{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "tcxreader";
  version = "0.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alenrajsp";
    repo = "tcxreader";
    rev = "v${version}";
    hash = "sha256-gPoYxdYCHVzSjCxhodRsbd60dGbPQtQQihdT0h3uVpU=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "tcxreader"
  ];

  meta = with lib; {
    description = "A reader for Garmin’s TCX file format.";
    homepage = "https://github.com/alenrajsp/tcxreader";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}

