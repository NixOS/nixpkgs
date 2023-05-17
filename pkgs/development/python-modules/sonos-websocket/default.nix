{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "sonos-websocket";
  version = "0.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jjlawren";
    repo = "sonos-websocket";
    rev = "refs/tags/${version}";
    hash = "sha256-8fHHaHvJKZOnzSaclt+TSQgcP2O6fmjU3+cF1nJpjOI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "sonos_websocket"
  ];

  meta = with lib; {
    description = "Library to communicate with Sonos devices over websockets";
    homepage = "https://github.com/jjlawren/sonos-websocket";
    changelog = "https://github.com/jjlawren/sonos-websocket/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
