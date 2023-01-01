{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pandas
, scipy
, fluids
, chemicals
, coolprop
}:
buildPythonPackage rec {
  pname = "thermo";
  version = "0.2.23";

  src = fetchFromGitHub {
    owner = "CalebBell";
    repo = "thermo";
    rev = "refs/tags/${version}";
    hash = "sha256-n58EdLW9PGj3MWugvqd4/yS53ZdChqhG6K+0Oeb+rAc=";
  };

  propagatedBuildInputs = [
    numpy
    pandas
    scipy
    coolprop
    fluids
    chemicals

  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/CalebBell/thermo";
    description = "Thermodynamics and Phase Equilibrium component of Chemical Engineering Design Library (ChEDL)";
    license = licenses.mit;
    maintainers = with maintainers; [ larsr ];
  };
}
