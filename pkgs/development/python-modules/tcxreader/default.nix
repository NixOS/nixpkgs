{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "tcxreader";
  version = "0.4.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alenrajsp";
    repo = "tcxreader";
    rev = "v${version}";
    hash = "sha256-UJ6F+GcdF0b2gALQWepLyCnWm+6RKBRnBt1eJNoRRzo=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "tcxreader"
  ];

  meta = with lib; {
    description = "A reader for Garmin’s TCX file format";
    homepage = "https://github.com/alenrajsp/tcxreader";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}

