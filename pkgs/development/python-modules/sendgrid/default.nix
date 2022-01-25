{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, pytestCheckHook
, python-http-client
, pythonOlder
, pyyaml
, starkbank-ecdsa
, werkzeug
}:

buildPythonPackage rec {
  pname = "sendgrid";
  version = "6.9.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = "sendgrid-python";
    rev = version;
    sha256 = "sha256-xNd0IPhaVw4X6URsg6hrDJhxmBRWam4bqgLN0uvMUxI=";
  };

  propagatedBuildInputs = [
    python-http-client
    starkbank-ecdsa
  ];

  checkInputs = [
    flask
    pytestCheckHook
    pyyaml
    werkzeug
  ];

  disabledTestPaths = [
    # Exclude tests that require network access
    "test/integ/test_sendgrid.py"
    "live_test.py"
  ];

  pythonImportsCheck = [
    "sendgrid"
  ];

  meta = with lib; {
    description = "Python client for SendGrid";
    homepage = "https://github.com/sendgrid/sendgrid-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
