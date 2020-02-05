{ lib
, buildPythonPackage
, fetchPypi
, flask
, pyyaml
, python-http-client
, six
, pytest
, mock
, codecov
, coverage
, fetchurl
}:
 
buildPythonPackage rec {
  pname = "sendgrid";
  version = "6.1.1"; 
 
  src = fetchPypi {
    inherit pname version;
    sha256 = "5ad98598c13b8cf5545d20f6fb6ecf967a08b48e3e175affabd82cfc71522d01";
  };

 checkPhase = ''
  test --ignore=tests/test_app.py
 '';
 
 propagatedBuildInputs = [ flask pyyaml six pytest mock codecov coverage python-http-client];
 
  meta = with lib; {
    description = "Twilio SendGrid library for Python";
    homepage = "https://github.com/sendgrid/sendgrid-python";
    license = licenses.mit;
    maintainers = with maintainers; [ xfoxawy ];
  };
}