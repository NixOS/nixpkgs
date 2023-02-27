{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, cryptography
, suds-jurko
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "transip";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "benkonrath";
    repo = "transip-api";
    rev = "v${version}";
    hash = "sha256-J/zcDapry8pm1zozzCDzrQED7vvCR6yoE4NcduBFfZQ=";
  };

  propagatedBuildInputs = [
    requests
    cryptography
    suds-jurko
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Constructor tests require network access
    "test_constructor"
    "testConstructor"
  ];

  pythonImportsCheck = [
    "transip"
  ];

  meta = with lib; {
    description = "TransIP API Connector";
    homepage = "https://github.com/benkonrath/transip-api";
    license = licenses.mit;
    maintainers = with maintainers; [ flyfloh ];
  };
}
