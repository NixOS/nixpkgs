{ lib, buildPythonPackage, fetchPypi, future, python-dateutil, six, pytest, mock, parameterized }:

buildPythonPackage rec {
  pname = "vertica-python";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cfe1794c5ba9fdfbd470a55d82f60c2e08e129828367753bf64199a58a539bc2";
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
