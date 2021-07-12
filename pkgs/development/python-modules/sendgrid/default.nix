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
  version = "6.7.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = "sendgrid-python";
    rev = version;
    sha256 = "0g9yifv3p3zbcxbcdyg4p9k3vwvaq0vym40j3yrv534m4qbynwhk";
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
