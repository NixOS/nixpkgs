{
  lib,
  buildPythonPackage,
  cryptography,
  ecdsa,
  fetchFromGitHub,
  flask,
  pytestCheckHook,
  python-http-client,
  pyyaml,
  setuptools,
  starkbank-ecdsa,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "sendgrid";
  version = "6.12.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = pname;
    repo = "sendgrid-python";
    tag = version;
    hash = "sha256-7r1FHcGmHRQK9mfpV3qcuZlIe7G6CIyarnpWLjduw4E=";
  };

  pythonRelaxDeps = [ "cryptography" ];

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    ecdsa
    python-http-client
    starkbank-ecdsa
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
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
