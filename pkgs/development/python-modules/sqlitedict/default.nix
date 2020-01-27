{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "sqlitedict";
  version = "1.6.0";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "483d6a063c4648dec68d413eb29df74399661f8541dcb3ee926d28fc2f82cb24";
  };
    
  meta = with lib; {
    description = "Persistent, thread-safe dict";
    homepage = "https://github.com/piskvorky/sqlitedict";
    license = licenses.asl20;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
