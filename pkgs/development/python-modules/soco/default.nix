{ lib, buildPythonPackage, fetchPypi, xmltodict, requests
, toml

# Test dependencies
, pytest, pytestcov, coveralls, pylint, flake8, graphviz, mock, sphinx
, sphinx_rtd_theme
}:

buildPythonPackage rec {
  pname = "soco";
  version = "0.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "929d4fae20b32efc08bb9985798c592aa7268162885541513eddbff0a757418f";
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
