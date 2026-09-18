{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,

  # build-system
  hatchling,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "testtools";
  version = "2.9.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Oa2eueG5NdaDj0s67k1ucttl31YC9v7amY27T+jeCxk=";
  };

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  pythonRemoveDeps = [ "fixtures" ];

  # testscenarios has a circular dependency on testtools
  doCheck = false;

  meta = {
    description = "Set of extensions to the Python standard library's unit testing framework";
    homepage = "https://github.com/testing-cabal/testtools";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
