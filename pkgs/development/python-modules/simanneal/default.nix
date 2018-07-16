{ stdenv, fetchFromGitHub, buildPythonPackage, pytest }:

buildPythonPackage rec {
  pname = "simanneal";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "perrygeo";
    repo = "simanneal";
    rev = version;
    sha256 = "12499wvf7ii7cy8z2f1d472p7q9napg1lj0h9xx8l1mbr1hjlp3q";
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
