{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-htmlhelp";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e8f5bb7e31b2dbb25b9cc435c8ab7a79787ebf7f906155729338f3156d93659b";
  };


  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  meta = with stdenv.lib; {
    description = "sphinxcontrib-htmlhelp is a sphinx extension which ...";
    homepage = "http://sphinx-doc.org/";
    license = licenses.bsd0;
  };

}
