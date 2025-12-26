{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyjwt,
  pypasser,
  requests,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "tami4edgeapi";
  version = "3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Guy293";
    repo = "Tami4EdgeAPI";
    tag = "v${version}";
    hash = "sha256-rhJ8L6qLDnO50Xp2eqquRinDTQjMxWVSjNL5GQI1gvM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyjwt
    pypasser
    requests
  ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "Tami4EdgeAPI" ];

  meta = {
    description = "Python API client for Tami4 Edge / Edge+ devices";
    homepage = "https://github.com/Guy293/Tami4EdgeAPI";
    changelog = "https://github.com/Guy293/Tami4EdgeAPI/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
