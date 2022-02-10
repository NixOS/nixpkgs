{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "teamcity-messages";
  version = "1.30";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JetBrains";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5C9ElCmTH+xSrFQ/x9IRJ89RfSd9cxzkETlOCzwyU8s=";
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
