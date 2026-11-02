{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cliff,
  fixtures,
  flit-core,
  python-subunit,
  testtools,
  tomlkit,
  voluptuous,
  callPackage,
}:

buildPythonPackage (finalAttrs: {
  pname = "stestr";
  version = "4.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mtreinish";
    repo = "stestr";
    tag = finalAttrs.version;
    hash = "sha256-S3fsqVu+E6eEJT95Gwola1ArPyMw1eIQ7pFf1Vka5SE=";
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
})
