{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
, responses
}:

buildPythonPackage rec {
  pname = "tesla-powerwall";
  version = "0.3.18";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jrester";
    repo = "tesla_powerwall";
    rev = "v${version}";
    hash = "sha256-Z+axzTiKDgJqGhl2c6g7N1AbmXO46lbaHVOXhMstoCY=";
  };

  propagatedBuildInputs = [
    requests
  ];

  checkInputs = [
    pytestCheckHook
    responses
  ];

  pytestFlagsArray = [
    "tests/unit"
  ];

  pythonImportsCheck = [
    "tesla_powerwall"
  ];

  meta = with lib; {
    description = "API for Tesla Powerwall";
    homepage = "https://github.com/jrester/tesla_powerwall";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
