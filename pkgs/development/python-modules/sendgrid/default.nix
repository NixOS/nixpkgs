{ lib, buildPythonPackage, fetchFromGitHub, flask, pytestCheckHook
, python-http-client, pyyaml, starkbank-ecdsa, werkzeug }:

buildPythonPackage rec {
  pname = "sendgrid";
  version = "6.9.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = "sendgrid-python";
    rev = version;
    sha256 = "sha256-eqmYuVW912E8hiVReLAoclmNDc2+gOIcUo9lRUx9AwM=";
  };

  propagatedBuildInputs = [ python-http-client starkbank-ecdsa ];

  checkInputs = [ flask pytestCheckHook pyyaml werkzeug ];

  # Exclude tests that require network access
  pytestFlagsArray =
    [ "--ignore test/test_sendgrid.py" "--ignore live_test.py" ];

  pythonImportsCheck = [ "sendgrid" ];

  meta = with lib; {
    description = "Python client for SendGrid";
    homepage = "https://github.com/sendgrid/sendgrid-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
