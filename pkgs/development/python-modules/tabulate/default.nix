{ lib
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  version = "0.7.7";
  pname = "tabulate";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "83a0b8e17c09f012090a50e1e97ae897300a72b35e0c86c0b53d3bd2ae86d8c6";
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