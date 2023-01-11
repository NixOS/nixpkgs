{ lib
, buildPythonPackage
, fetchPypi
, nose
, setuptools-scm
, setuptools
}:

buildPythonPackage rec {
  version = "0.9.0";
  pname = "tabulate";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AJWxK/WWbeUpwP6x+ghnFnGzNo7sd9fverEUviwGizw=";
  };

  checkInputs = [ nose ];
  nativeBuildInputs = [ setuptools setuptools-scm ];

  # Tests: cannot import common (relative import).
  doCheck = false;

  meta = {
    description = "Pretty-print tabular data";
    homepage = "https://github.com/astanin/python-tabulate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
