{
  lib,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  pbr,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "os-service-types";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "os-service-types";
    tag = finalAttrs.version;
    hash = "sha256-odTaEbu9ivcmcxR6KDiyv3TiooARSD8rE9xYZ9ww7lI=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt

    # pbr needs git to ship subpackages and package data
    echo "recursive-include os_service_types *" > MANIFEST.in
  '';

  build-system = [ pbr ];

  dependencies = [
    pbr
    typing-extensions
  ];

  # check in passthru.tests.pytest to escape infinite recursion with other oslo components
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [
    "os_service_types"
    "os_service_types.data"
  ];

  meta = {
    description = "Python library for consuming OpenStack service-types-authority data";
    homepage = "https://github.com/openstack/os-service-types";
    changelog = "https://github.com/openstack/os-service-types/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
