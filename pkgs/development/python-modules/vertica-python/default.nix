{ lib, buildPythonPackage, fetchPypi, future, dateutil, six, pytest, mock, parameterized }:

buildPythonPackage rec {
  pname = "vertica-python";
  version = "0.10.3";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "0de23c0a09f0d849db626569207d52d324ffd51c69b4f7f3650f167c3c2c9de9";
  };
  
  propagatedBuildInputs = [ future dateutil six ];
  
  checkInputs = [ pytest mock parameterized ];
  
  # Integration tests require an accessible Vertica db
  checkPhase = ''
    pytest --ignore vertica_python/tests/integration_tests
  '';
  
  meta = with lib; {
    description = "Native Python client for Vertica database";
    homepage = "https://github.com/vertica/vertica-python";
    license = licenses.asl20;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
