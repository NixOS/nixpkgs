{ lib, buildPythonPackage, fetchFromGitHub, pytest }:

buildPythonPackage rec {
  pname = "sqlitedict";
  version = "1.6.0";
  
  src = fetchFromGitHub {
    owner = "RaRe-Technologies";
    repo = "sqlitedict";
    rev = version;
    sha256 = "1yq94lgpny9qcfbsl39npjvrsjfggi3lj2kpzcsxcfdfgxag6m2m";
  };
  
  checkInputs = [ pytest ];
  
  checkPhase = ''
    pytest tests
  '';
  
  meta = with lib; {
    description = "Persistent, thread-safe dict";
    homepage = "https://github.com/RaRe-Technologies/sqlitedict";
    license = licenses.asl20;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
