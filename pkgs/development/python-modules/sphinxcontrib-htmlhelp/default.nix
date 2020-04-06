{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-htmlhelp";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4670f99f8951bd78cd4ad2ab962f798f5618b17675c35c5ac3b2132a14ea8422";
  };


  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  meta = with stdenv.lib; {
    description = "sphinxcontrib-htmlhelp is a sphinx extension which ...";
    homepage = http://sphinx-doc.org/;
    license = licenses.bsd0;
  };

}
