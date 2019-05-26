{ lib
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  version = "0.8.3";
  pname = "tabulate";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8af07a39377cee1103a5c8b3330a421c2d99b9141e9cc5ddd2e3263fea416943";
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
