{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "teamcity-messages";
  version = "1.31";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JetBrains";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oYXP9HWdgmEq48rYyuX6zHf+cp835C0BtHUAME+5S+k=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/unit-tests/"
  ];

  pythonImportsCheck = [
    "teamcity"
  ];

  meta = with lib; {
    description = "Python unit test reporting to TeamCity";
    homepage = "https://github.com/JetBrains/teamcity-messages";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
