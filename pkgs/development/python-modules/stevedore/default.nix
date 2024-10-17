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
  version = "5.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mmQmX0BgMSgoFRwgTvvpt6mFKg2SKHVjRNvH5AI+N1o=";
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

  meta = with lib; {
    description = "Manage dynamic plugins for Python applications";
    homepage = "https://docs.openstack.org/stevedore/";
    license = licenses.asl20;
    maintainers = teams.openstack.members ++ (with maintainers; [ fab ]);
  };
}
