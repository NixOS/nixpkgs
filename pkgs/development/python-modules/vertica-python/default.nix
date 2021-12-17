{ lib, buildPythonPackage, fetchPypi, future, python-dateutil, six, pytest, mock, parameterized }:

buildPythonPackage rec {
  pname = "vertica-python";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ce0abfc5909d06031dc612ec321d7f75df50bcb47a31e14e882a299cea2ea7a3";
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
