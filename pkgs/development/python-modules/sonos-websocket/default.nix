{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sonos-websocket";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jjlawren";
    repo = "sonos-websocket";
    tag = version;
    hash = "sha256-Yf6osDW7+PYalj3bK7+wF2RotCVlcLJD1ulqLcxrdMU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "sonos_websocket" ];

  meta = {
    description = "Library to communicate with Sonos devices over websockets";
    homepage = "https://github.com/jjlawren/sonos-websocket";
    changelog = "https://github.com/jjlawren/sonos-websocket/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
