{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, pytestCheckHook
, python-http-client
, pyyaml
, starkbank-ecdsa
, werkzeug
}:

buildPythonPackage rec {
  pname = "sendgrid";
  version = "6.9.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = "sendgrid-python";
    rev = version;
    sha256 = "sha256-/4Wk+1zAFwK+FxRhABQBha43/zapgPDfTFGrPJjXA7s=";
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
