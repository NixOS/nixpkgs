{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
, pythonOlder
, requests
, responses
, setuptools
, urllib3
}:

buildPythonPackage rec {
  pname = "tank-utility";
  version = "1.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "krismolendyke";
    repo = pname;
    rev = version;
    hash = "sha256-2cxAaSyreIzQzCUtiolEV7JbGFKL8Mob3337J0jlMsU=";
  };

  propagatedBuildInputs = [
    requests
    urllib3
    setuptools
  ] ++ urllib3.optional-dependencies.secure;

  checkInputs = [
    responses
    mock
    pytestCheckHook
  ];


  pythonImportsCheck = [
    "tank_utility"
  ];

  meta = with lib; {
    description = "Library for the Tank Utility API";
    homepage = "https://github.com/krismolendyke/tank-utility";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
