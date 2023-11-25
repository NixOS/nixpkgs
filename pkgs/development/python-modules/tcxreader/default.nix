{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "tcxreader";
  version = "0.4.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alenrajsp";
    repo = "tcxreader";
    rev = "refs/tags/v${version}";
    hash = "sha256-CiOLcev9fo2BPgnPZZ2borU25f/gKISqRAapAHgLN3w=";
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

