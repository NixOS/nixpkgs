{ lib, buildPythonPackage, fetchPypi, future, dateutil, six, pytest, mock, parameterized }:

buildPythonPackage rec {
  pname = "vertica-python";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cceb39d081b8d1628956205642e740a9fabcfd2c6ecd982c51134fba8215d0bd";
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
