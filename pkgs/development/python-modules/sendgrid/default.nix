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
  version = "6.5.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "sendgrid-python";
    rev = version;
    sha256 = "14kqjdv49486ksc1s0m0hc4k5nf9vn1v1g489mpib01hiiqxjp1b";
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

  # Exclude tests that require network access
  pytestFlagsArray = [
    "--ignore test/test_sendgrid.py"
    "--ignore live_test.py"
  ];

  pythonImportsCheck = [ "sendgrid" ];

  meta = with lib; {
    description = "Python client for SendGrid";
    homepage = "https://github.com/sendgrid/sendgrid-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
