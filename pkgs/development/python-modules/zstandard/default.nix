{ lib
, buildPythonPackage
, fetchPypi
, cffi
, hypothesis
}:

buildPythonPackage rec {
  pname = "zstandard";
  version = "0.14.0";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "0lkn7n3bfp7zip6hkqwkqwc8pxmhhs4rr699k77h51rfln6kjllh";
  };
  
  propagatedBuildInputs = [ cffi ];
  
  checkInputs = [ hypothesis ];
    
  meta = with lib; {
    description = "zstandard bindings for Python";
    homepage = "https://github.com/indygreg/python-zstandard";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
