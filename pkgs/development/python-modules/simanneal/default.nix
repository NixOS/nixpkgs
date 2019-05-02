{ stdenv, fetchFromGitHub, buildPythonPackage, pytest }:

buildPythonPackage rec {
  pname = "simanneal";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "perrygeo";
    repo = "simanneal";
    rev = version;
    sha256 = "0p75da4nbk6iy16aahl0ilqg605jrr6aa1pzfyd9hc7ak2vs6840";
  };

  checkInputs = [ pytest ];
  checkPhase = "pytest tests";

  meta = with stdenv.lib; {
    description = "A python implementation of the simulated annealing optimization technique";
    homepage = https://github.com/perrygeo/simanneal;
    license = licenses.isc;
    maintainers = with maintainers; [ veprbl ];
  };
}
