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
  version = "2.7.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-W+W7wfD6D4tgrKbO7AeEXUHQxHXPRFv6200sRew5fqM=";
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
