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
    sha256 = "eda689eda0c7301a80cf122dad28b1861e5605cbf455558f3775e1e8200e83a5";
  };

  propagatedBuildInputs = [ sphinx ];

  checkInputs = [ readthedocs-sphinx-ext pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "ReadTheDocs.org theme for Sphinx";
    homepage = "https://github.com/snide/sphinx_rtd_theme/";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };

}
