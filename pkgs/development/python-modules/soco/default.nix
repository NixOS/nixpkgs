{ lib, buildPythonPackage, fetchPypi, xmltodict, requests
, toml

# Test dependencies
, pytest, pytestcov, coveralls, pylint, flake8, graphviz, mock, sphinx
, sphinx_rtd_theme
}:

buildPythonPackage rec {
  pname = "soco";
  version = "0.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dgca286vhrabm4r4jj545k895z6w2c70ars06vrjhf9cpgg7qck";
  };

  propagatedBuildInputs = [ xmltodict requests toml ];
  checkInputs = [
    pytest pytestcov coveralls pylint flake8 graphviz mock sphinx
    sphinx_rtd_theme
  ];

  meta = {
    homepage = "http://python-soco.com/";
    description = "A CLI and library to control Sonos speakers";
    license = lib.licenses.mit;
  };
}
