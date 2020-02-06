{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-serializinghtml";
  version = "1.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c0efb33f8052c04fd7a26c0a07f1678e8512e0faec19f4aa8f2473a8b81d5227";
  };


  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  meta = with stdenv.lib; {
    description = "sphinxcontrib-serializinghtml is a sphinx extension which outputs \"serialized\" HTML files (json and pickle).";
    homepage = http://sphinx-doc.org/;
    license = licenses.bsd0;
  };

}
