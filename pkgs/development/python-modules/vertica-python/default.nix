{ lib, buildPythonPackage, fetchPypi, future, dateutil, six, pytest, mock, parameterized }:

buildPythonPackage rec {
  pname = "vertica-python";
  version = "0.10.4";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "570525d0371806993874bd2ee0f47cc5d68994abb5aa382e964e53e0b81160b2";
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
