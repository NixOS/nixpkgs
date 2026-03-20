{
  lib,
  buildPythonPackage,
  callPackage,
  fetchPypi,
  pbr,
  setuptools,
}:

buildPythonPackage rec {
  pname = "stevedore";
  version = "5.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8i0VxurUDFu/qcpUqn57SgfVmzauA+0SztGlTPC1GUU=";
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
