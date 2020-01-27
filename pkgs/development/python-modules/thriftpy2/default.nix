{ lib, buildPythonPackage, fetchPypi, ply, tornado }:

buildPythonPackage rec {
  pname = "thriftpy2";
  version = "0.4.10";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "0bd98580bdb1d1184338e5f105b685f55f3fd60e6335c72d9bb7634ed284cc57";
  };
  
  propagatedBuildInputs = [ ply ];
  
  checkInputs = [ tornado ];
    
  meta = with lib; {
    description = "Pure python implementation of Apache Thrift";
    homepage = "https://thriftpy2.readthedocs.io/";
    license = licenses.mit;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
