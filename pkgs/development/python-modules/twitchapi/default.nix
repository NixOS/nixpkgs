{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, aiohttp
, python-dateutil
, requests
, typing-extensions
, websockets
}:

buildPythonPackage rec {
  pname = "twitchapi";
  version = "2.5.7.1";

  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchPypi {
    pname = "twitchAPI";
    inherit version;
    hash = "sha256-ZhmzrHWbwoHL+9FdkVoc+GGxH1v2j7rB/3ZiaWu9kjQ=";
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
