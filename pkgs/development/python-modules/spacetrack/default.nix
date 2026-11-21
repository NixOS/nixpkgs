{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
  wheel,

  # dependencies
  filelock,
  httpx,
  logbook,
  outcome,
  platformdirs,
  represent,
  rush,
  sniffio,
}:

buildPythonPackage (finalAttrs: {

  pname = "spacetrack";

  version = "1.4.0";

  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-/ktUw97eBJag7MQDkhFIGiWuT70O/15UGQRB8NRDTHQ=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    filelock
    httpx
    logbook
    outcome
    platformdirs
    represent
    rush
    sniffio
  ];

  meta = {
    changelog = "https://spacetrack.readthedocs.io/en/stable/changelog.html";
    description = "Python libary for querying the space-track.org API";
    homepage = "https://spacetrack.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eidoom ];
  };

})
