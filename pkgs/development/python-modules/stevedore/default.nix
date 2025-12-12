{
  lib,
  buildPythonPackage,
  callPackage,
  fetchPypi,
  pythonOlder,
  pbr,
  setuptools,
}:

buildPythonPackage rec {
  pname = "stevedore";
  version = "5.4.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MTW1rlD+EoFu8pG6/0IKy3J/zTVhBuPpy/qeWYXNb0s=";
  };

  build-system = [
    pbr
    setuptools
  ];

  # Checks moved to 'passthru.tests' to workaround infinite recursion
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "stevedore" ];

  meta = {
    description = "Manage dynamic plugins for Python applications";
    homepage = "https://github.com/openstack/stevedore";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
