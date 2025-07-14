{
  lib,
  buildPythonPackage,
  fetchPypi,
  cliff,
  fixtures,
  flit-core,
  subunit,
  testtools,
  tomlkit,
  voluptuous,
  callPackage,
}:

buildPythonPackage rec {
  pname = "stestr";
  version = "4.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Rexjny0cw3LjYwYTuT83zynT3+adSdTz+UCNN7Ebwpw=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [
    cliff
    fixtures
    subunit
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

  meta = with lib; {
    description = "Parallel Python test runner built around subunit";
    mainProgram = "stestr";
    homepage = "https://github.com/mtreinish/stestr";
    license = licenses.asl20;
    teams = [ teams.openstack ];
  };
}
