{ stdenv
, buildPythonPackage
, fetchPypi
, sphinx
, readthedocs-sphinx-ext
, pytest
}:

buildPythonPackage rec {
  pname = "sphinx_rtd_theme";
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "728607e34d60456d736cc7991fd236afb828b21b82f956c5ea75f94c8414040a";
  };

  propagatedBuildInputs = [ sphinx ];

  checkInputs = [ readthedocs-sphinx-ext pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "ReadTheDocs.org theme for Sphinx";
    homepage = "https://github.com/snide/sphinx_rtd_theme/";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };

}
