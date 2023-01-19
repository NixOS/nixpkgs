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
  version = "0.3.19";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jrester";
    repo = "tesla_powerwall";
    rev = "refs/tags/v${version}";
    hash = "sha256-ClrMgPAMBtDMfD6hCJIN1u4mp75QW+c3re28v3FreQg=";
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
    changelog = "https://github.com/jrester/tesla_powerwall/blob/v${version}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
