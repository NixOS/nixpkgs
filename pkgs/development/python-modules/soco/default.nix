{ lib, buildPythonPackage, fetchPypi, xmltodict, requests

# Test dependencies
, pytest, pytestcov, coveralls, pylint, flake8, graphviz, mock, sphinx
, sphinx_rtd_theme
}:

buildPythonPackage rec {
  pname = "soco";
  version = "0.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bf55mqnz3l3ii26dvx33d35fv7jn7p5kmfwnr0xbpj38sxvhfr4";
  };

  postPatch = ''
    # https://github.com/SoCo/SoCo/pull/670
    substituteInPlace requirements-dev.txt \
      --replace "pytest-cov>=2.4.0,<2.6" "pytest-cov>=2.4.0"
  '';

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
