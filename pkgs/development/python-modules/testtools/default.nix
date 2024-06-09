{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,
  pythonRelaxDepsHook,

  # build-system
  hatchling,
  hatch-vcs,

  # dependencies
  setuptools,
}:

buildPythonPackage rec {
  pname = "testtools";
  version = "2.7.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-323pYBDinuIfY3oUfqvzDVCyXjhB3R1o+T7onOd+Nmw=";
  };

  nativeBuildInputs = [
    hatchling
    hatch-vcs
    pythonRelaxDepsHook
  ];

  pythonRemoveDeps = [ "fixtures" ];

  propagatedBuildInputs = lib.optionals (pythonAtLeast "3.12") [ setuptools ];

  # testscenarios has a circular dependency on testtools
  doCheck = false;

  meta = {
    description = "A set of extensions to the Python standard library's unit testing framework";
    homepage = "https://pypi.python.org/pypi/testtools";
    license = lib.licenses.mit;
  };
}
