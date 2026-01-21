{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,

  # build-system
  hatchling,
  hatch-vcs,

  # dependencies
  setuptools,
}:

buildPythonPackage rec {
  pname = "testtools";
  version = "2.8.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tcczMkVv9UFSBi1HpYvE8V+OI1FK/sToR3WvEk+320M=";
  };

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  pythonRemoveDeps = [ "fixtures" ];

  propagatedBuildInputs = lib.optionals (pythonAtLeast "3.12") [ setuptools ];

  # testscenarios has a circular dependency on testtools
  doCheck = false;

  meta = {
    description = "Set of extensions to the Python standard library's unit testing framework";
    homepage = "https://github.com/testing-cabal/testtools";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
