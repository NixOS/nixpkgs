{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
, responses
, setuptools
}:

buildPythonPackage rec {
  pname = "tesla-powerwall";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jrester";
    repo = "tesla_powerwall";
    rev = "refs/tags/v${version}";
    hash = "sha256-IqUxWwEvrSEbLAEnHG84oCV75qO0L5LmgpHOfaM6G8o=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
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
