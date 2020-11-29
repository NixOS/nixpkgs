{ stdenv
, buildPythonPackage
, fetchPypi
, sphinx
, readthedocs-sphinx-ext
, pytest
}:

buildPythonPackage rec {
  pname = "sphinx_rtd_theme";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "22c795ba2832a169ca301cd0a083f7a434e09c538c70beb42782c073651b707d";
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
