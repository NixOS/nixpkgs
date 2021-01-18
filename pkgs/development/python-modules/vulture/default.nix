{ lib, stdenv, buildPythonPackage, fetchPypi, isPy27, coverage, pytest, pytestcov }:

buildPythonPackage rec {
  pname = "vulture";
  version = "2.3";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ryrmsm72z3fzaanyblz49q40h9d3bbl4pspn2lvkkp9rcmsdm83";
  };

  checkInputs = [ coverage pytest pytestcov ];
  checkPhase = "pytest";

  meta = with lib; {
    description = "Finds unused code in Python programs";
    homepage = "https://github.com/jendrikseipp/vulture";
    license = licenses.mit;
    maintainers = with maintainers; [ mcwitt ];
  };
}
