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
  version = "2.5.2";

  format = "setuptools";

  src = fetchPypi {
    pname = "twitchAPI";
    inherit version;
    sha256 = "f0ee5388911154375170a83df9a18e8a698fe382cea5d94a3e33ad27a7ce9133";
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
    maintainers = with maintainers; [ dotlambda ];
  };
}
