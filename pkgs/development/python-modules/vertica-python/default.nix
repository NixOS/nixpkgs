{ lib, buildPythonPackage, fetchPypi, future, python-dateutil, six, pytest, mock, parameterized }:

buildPythonPackage rec {
  pname = "vertica-python";
  version = "1.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IpdrR9mDG+8cNnXgSXkmXahSEP4EGnEBJqZk5SNu9pA=";
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
