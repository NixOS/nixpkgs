{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-devhelp";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6c64b077937330a9128a4da74586e8c2130262f014689b4b89e2d08ee7294a34";
  };


  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  meta = with stdenv.lib; {
    description = "sphinxcontrib-devhelp is a sphinx extension which outputs Devhelp document.";
    homepage = http://sphinx-doc.org/;
    license = licenses.bsd0;
  };

}
