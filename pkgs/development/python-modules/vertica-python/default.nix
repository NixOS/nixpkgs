{ lib, buildPythonPackage, fetchPypi, future, dateutil, six, pytest, mock, parameterized }:

buildPythonPackage rec {
  pname = "vertica-python";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f042cf60ddd69eeb17c9f1586bae25da5b7282ca53d9afe0be30b943b4194d52";
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
