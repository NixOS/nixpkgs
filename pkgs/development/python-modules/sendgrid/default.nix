{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, pytestCheckHook
, python-http-client
, pythonOlder
, pyyaml
, starkbank-ecdsa
, six
, werkzeug
}:

buildPythonPackage rec {
  pname = "sendgrid";
  version = "6.9.7";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = "sendgrid-python";
    rev = version;
    sha256 = "sha256-Lx84jmgJz/J5MJtJyqDTVIbN6H63gD2rkJrdNeojd08=";
  };

  propagatedBuildInputs = [
    python-http-client
    starkbank-ecdsa
    six
  ];

  nativeCheckInputs = [
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
