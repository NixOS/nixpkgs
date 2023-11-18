{ lib
, buildPythonPackage
, fetchPypi
, pythonRelaxDepsHook
, pbr
, python-mimeparse
, extras
, traceback2
, testscenarios
}:

buildPythonPackage rec {
  pname = "testtools";
  version = "2.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-323pYBDinuIfY3oUfqvzDVCyXjhB3R1o+T7onOd+Nmw=";
  };

  propagatedBuildInputs = [ pbr python-mimeparse extras ];
  buildInputs = [ traceback2 ];
  nativeBuildInputs = [ pythonRelaxDepsHook ];

  # testscenarios has a circular dependency on testtools
  doCheck = false;
  nativeCheckInputs = [ testscenarios ];

  pythonRemoveDeps = [ "fixtures" ];

  meta = {
    description = "A set of extensions to the Python standard library's unit testing framework";
    homepage = "https://pypi.python.org/pypi/testtools";
    license = lib.licenses.mit;
  };
}
