{ lib, fetchFromGitHub, buildPythonPackage, pytest }:

buildPythonPackage rec {
  pname = "simanneal";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "perrygeo";
    repo = "simanneal";
    rev = version;
    sha256 = "sha256-yKZHkrf6fM0WsHczIEK5Kxusz5dSBgydK3fLu1nDyvk=";
  };

  checkInputs = [ pytest ];
  checkPhase = "pytest tests";

  meta = with lib; {
    description = "A python implementation of the simulated annealing optimization technique";
    homepage = "https://github.com/perrygeo/simanneal";
    license = licenses.isc;
    maintainers = with maintainers; [ veprbl ];
  };
}
