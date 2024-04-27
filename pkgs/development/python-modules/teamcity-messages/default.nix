{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "teamcity-messages";
  version = "1.32";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JetBrains";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9az7kD7nKqMF2b3/eFgF+pOKKIYLvTy2sf4TSJfHRnA=";
  };

  nativeCheckInputs = [
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
