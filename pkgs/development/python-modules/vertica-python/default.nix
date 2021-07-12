{ lib, buildPythonPackage, fetchPypi, future, python-dateutil, six, pytest, mock, parameterized }:

buildPythonPackage rec {
  pname = "vertica-python";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "94cff37e03f89fc4c5e4b2d4c913c7d5d7450f5a205d14f709b39e0a4202be95";
  };

  propagatedBuildInputs = [ future python-dateutil six ];

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
