{ lib
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  version = "0.8.7";
  pname = "tabulate";

  src = fetchPypi {
    inherit pname version;
    sha256 = "db2723a20d04bcda8522165c73eea7c300eda74e0ce852d9022e0159d7895007";
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
