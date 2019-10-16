{ lib
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  version = "0.8.5";
  pname = "tabulate";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d0097023658d4dea848d6ae73af84532d1e86617ac0925d1adf1dd903985dac3";
  };

  checkInputs = [ nose ];

  # Tests: cannot import common (relative import).
  doCheck = false;

  meta = {
    description = "Pretty-print tabular data";
    homepage = https://bitbucket.org/astanin/python-tabulate;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
