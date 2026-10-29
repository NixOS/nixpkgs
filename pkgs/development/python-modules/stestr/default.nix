{
  lib,
  buildPythonPackage,
  fetchPypi,
  cliff,
  fixtures,
  flit-core,
  python-subunit,
  testtools,
  tomlkit,
  voluptuous,
  callPackage,
}:

buildPythonPackage rec {
  pname = "stestr";
  version = "4.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tgSVIl+ng0diUlcq3aKdM643BvlfwyVk94+058nl3yA=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [
    cliff
    fixtures
    python-subunit
    testtools
    tomlkit
    voluptuous
  ];

  # check in passthru.tests.pytest to escape infinite recursion with other oslo components
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "stestr" ];

  meta = {
    description = "Parallel Python test runner built around subunit";
    mainProgram = "stestr";
    homepage = "https://github.com/mtreinish/stestr";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
