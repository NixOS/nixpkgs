{
  lib,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  pbr,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "stevedore";
  version = "5.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "stevedore";
    tag = finalAttrs.version;
    hash = "sha256-peKMn3Oa9B+HlvLYKIyFzVpS5h65tYg5MKCgjnr0s6M=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

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
})
