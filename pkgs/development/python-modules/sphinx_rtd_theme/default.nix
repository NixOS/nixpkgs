{ stdenv
, buildPythonPackage
, fetchPypi
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx_rtd_theme";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02f02a676d6baabb758a20c7a479d58648e0f64f13e07d1b388e9bb2afe86a09";
  };

  propagatedBuildInputs = [ sphinx ];

  meta = with stdenv.lib; {
    description = "ReadTheDocs.org theme for Sphinx";
    homepage = https://github.com/snide/sphinx_rtd_theme/;
    license = licenses.bsd3;
    platforms = platforms.unix;
  };

}
