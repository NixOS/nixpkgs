{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sphinx_rtd_theme";
  version = "0.2.5b2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0grf16fi4g0p3dfh11b1624ic34iqkjhf5i1g6hvsh4nlm0ll00q";
  };

  meta = with stdenv.lib; {
    description = "ReadTheDocs.org theme for Sphinx";
    homepage = https://github.com/snide/sphinx_rtd_theme/;
    license = licenses.bsd3;
    platforms = platforms.unix;
  };

}
