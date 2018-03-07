{ lib
, buildPythonPackage
, fetchPypi
, nose
, version ? "0.8.2"
, sha256 ? "e4ca13f26d0a6be2a2915428dc21e732f1e44dad7f76d7030b2ef1ec251cf7f2"
}:

buildPythonPackage rec {
  inherit version;
  pname = "tabulate";

  src = fetchPypi {
    inherit pname version sha256;
  };

  checkInputs = [ nose ];

  # Tests: cannot import common (relative import).
  doCheck = false;

  meta = {
    description = "Pretty-print tabular data";
    homepage = https://bitbucket.org/astanin/python-tabulate;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fridh rubbish ];
  };
}
