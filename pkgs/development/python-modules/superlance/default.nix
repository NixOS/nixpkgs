{ lib, buildPythonPackage, fetchPypi, supervisor }:

buildPythonPackage rec {
  pname = "superlance";
  version = "1.0.0";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "f697c71341e9a686f3a0ff3f04a82448523eac0a6121484933729ba65a973a63";
  };
    
  propagatedBuildInputs = [ supervisor ];
  
  meta = with lib; {
    description = "Superlance plugins for supervisord";
    homepage = "https://github.com/Supervisor/superlance";
    license = licenses.free; # http://www.repoze.org/LICENSE.txt
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
