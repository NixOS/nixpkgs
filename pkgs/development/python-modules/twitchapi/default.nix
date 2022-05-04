{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, python-dateutil
, requests
, typing-extensions
, websockets
}:

buildPythonPackage rec {
  pname = "twitchapi";
  version = "2.5.3";

  format = "setuptools";

  src = fetchPypi {
    pname = "twitchAPI";
    inherit version;
    sha256 = "e7987dd8c3d1a3d25fe85ff0c0b0bad492f916c920f618dca8efd6baad3ac704";
  };

  propagatedBuildInputs = [
    aiohttp
    python-dateutil
    requests
    typing-extensions
    websockets
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "twitchAPI.eventsub"
    "twitchAPI.oauth"
    "twitchAPI.pubsub"
    "twitchAPI.twitch"
    "twitchAPI.types"
  ];

  meta = with lib; {
    description = "Python implementation of the Twitch Helix API, its Webhook, PubSub and EventSub";
    homepage = "https://github.com/Teekeks/pyTwitchAPI";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda wolfangaukang ];
  };
}
