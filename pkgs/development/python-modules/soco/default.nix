{ lib, buildPythonPackage, fetchPypi, xmltodict, requests

# Test dependencies
, pytest, pytestcov, coveralls, pylint, flake8, graphviz, mock, sphinx
, sphinx_rtd_theme
}:

buildPythonPackage rec {
  pname = "soco";
  version = "0.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18bxpbd7l9gns0jpvx09z023kbbz7b6i4f99i8silsb1jv682kg0";
  };

  propagatedBuildInputs = [ xmltodict requests ];
  checkInputs = [
    pytest pytestcov coveralls pylint flake8 graphviz mock sphinx
    sphinx_rtd_theme
  ];

  meta = {
    homepage = http://python-soco.com/;
    description = "A CLI and library to control Sonos speakers";
    license = lib.licenses.mit;
  };
}
