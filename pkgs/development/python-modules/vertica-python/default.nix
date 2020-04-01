{ lib, buildPythonPackage, fetchPypi, future, dateutil, six, pytest, mock, parameterized }:

buildPythonPackage rec {
  pname = "vertica-python";
  version = "0.10.2";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "c35d0e7ac8da2af47a65efc72d5d8351caa93e4829e549f229aa7e375593f896";
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
