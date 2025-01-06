{
  lib,
  buildPythonPackage,
  callPackage,
  fetchPypi,
  pythonOlder,
  importlib-metadata,
  pbr,
  setuptools,
}:

buildPythonPackage rec {
  pname = "stevedore";
  version = "5.4.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eekiNey4KP6VK2uLDGyHhjJIYxkiyOjg+lsXsjLEUU0=";
  };

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [
    importlib-metadata
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
    homepage = "https://docs.openstack.org/stevedore/";
    license = lib.licenses.asl20;
    maintainers = lib.teams.openstack.members ++ (with lib.maintainers; [ fab ]);
  };
}
