{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, readthedocs-sphinx-ext
, pytest
}:

buildPythonPackage rec {
  pname = "sphinx_rtd_theme";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19c31qhfiqbm6y7mamglrc2mc7l6n4lasb8jry01lc67l3nqk9pd";
  };

  propagatedBuildInputs = [ sphinx ];

  checkInputs = [ readthedocs-sphinx-ext pytest ];
  CI=1; # Don't use NPM to fetch assets. Assets are included in sdist.

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "ReadTheDocs.org theme for Sphinx";
    homepage = "https://github.com/readthedocs/sphinx_rtd_theme";
    license = licenses.mit;
    platforms = platforms.unix;
  };

}
