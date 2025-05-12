{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  pytestCheckHook,
  python-http-client,
  pythonOlder,
  pyyaml,
  starkbank-ecdsa,
  six,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "sendgrid";
  version = "6.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = "sendgrid-python";
    tag = version;
    hash = "sha256-+1Tkue09C2qqCqN8lbseo2MzVbx+qDE/M/3r3Q6EXYE=";
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

  pythonImportsCheck = [ "sendgrid" ];

  meta = with lib; {
    description = "Python client for SendGrid";
    homepage = "https://github.com/sendgrid/sendgrid-python";
    changelog = "https://github.com/sendgrid/sendgrid-python/blob/${src.tag}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
