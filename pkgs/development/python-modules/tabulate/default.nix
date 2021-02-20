{ lib
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  version = "0.8.8";
  pname = "tabulate";

  src = fetchPypi {
    inherit pname version;
    sha256 = "26f2589d80d332fefd2371d396863dedeb806f51b54bdb4b264579270b621e92";
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
