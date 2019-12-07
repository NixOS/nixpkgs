{ lib
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  version = "0.8.6";
  pname = "tabulate";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5470cc6687a091c7042cee89b2946d9235fe9f6d49c193a4ae2ac7bf386737c8";
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
