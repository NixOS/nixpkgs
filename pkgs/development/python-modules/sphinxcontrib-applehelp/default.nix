{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-applehelp";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "edaa0ab2b2bc74403149cb0209d6775c96de797dfd5b5e2a71981309efab3897";
  };


  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  meta = with stdenv.lib; {
    description = "sphinxcontrib-applehelp is a sphinx extension which outputs Apple help books";
    homepage = http://sphinx-doc.org/;
    license = licenses.bsd0;
  };

}
