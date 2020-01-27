{ lib, buildPythonPackage, fetchPypi, psutil, nose }:

buildPythonPackage rec {
  pname = "supervisor_checks";
  version = "0.8.1";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "1474150aed0acdea726cc9ffdf6b728e2ed8aa8ef89d8d979cd2fb8f4444d987";
  };
  
  propagatedBuildInputs = [ psutil ];
  
  checkInputs = [ nose ];
  
  meta = with lib; {
    description = "Health-check framework for Supervisor-based services";
    homepage = "https://github.com/vovanec/supervisor_checks";
    license = licenses.mit;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
