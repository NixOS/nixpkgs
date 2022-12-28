{ lib
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  version = "0.8.10";
  pname = "tabulate";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-bFfz8916wngncBVfOtstsLGiaWN+QvJ1mZJeZLEU9Rk=";
  };

  checkInputs = [ nose ];

  # Tests: cannot import common (relative import).
  doCheck = false;

  meta = {
    description = "Pretty-print tabular data";
    homepage = "https://github.com/astanin/python-tabulate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
