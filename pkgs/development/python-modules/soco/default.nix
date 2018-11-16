{ lib, buildPythonPackage, fetchPypi, xmltodict, requests

# Test dependencies
, pytest, pytestcov, coveralls, pylint, flake8, graphviz, mock, sphinx
, sphinx_rtd_theme
}:

buildPythonPackage rec {
  pname = "soco";
  version = "0.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7bed4475e3f134283af1f520a9b2e6ce2a8e69bdc1b58ee68528b3d093972424";
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
