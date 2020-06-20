{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-qthelp";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c33767ee058b70dba89a6fc5c1892c0d57a54be67ddd3e7875a18d14cba5a72";
  };


  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  meta = with stdenv.lib; {
    description = "sphinxcontrib-qthelp is a sphinx extension which outputs QtHelp document.";
    homepage = "http://sphinx-doc.org/";
    license = licenses.bsd0;
  };

}
