{ lib
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  version = "0.8.9";
  pname = "tabulate";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eb1d13f25760052e8931f2ef80aaf6045a6cceb47514db8beab24cded16f13a7";
  };

  checkInputs = [ nose ];

  # Tests: cannot import common (relative import).
  doCheck = false;

  meta = {
    description = "Pretty-print tabular data";
    homepage = "https://bitbucket.org/astanin/python-tabulate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
