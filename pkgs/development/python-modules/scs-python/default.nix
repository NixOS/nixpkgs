{ lib, buildPythonPackage, fetchPypi, nose, numpy, scipy }:

buildPythonPackage rec {
  pname = "scs";
  version = "2.1.1-2";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "f816cfe3d4b4cff3ac2b8b96588c5960ddd2a3dc946bda6b09db04e7bc6577f2";
  };

  propagatedBuildInputs = [ numpy scipy ];
  
  checkInputs = [ nose ];
  
  checkPhase = ''
    nosetests test
  '';
  
  meta = with lib; {
    description = "Interface for Splitting Conic Solver";
    homepage = "https://github.com/bodono/scs-python";
    license = licenses.mit;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
