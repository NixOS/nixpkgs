{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, aiohttp
, python-dateutil
, typing-extensions
}:

buildPythonPackage rec {
  pname = "twitchapi";
  version = "3.10.0";

  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchPypi {
    pname = "twitchAPI";
    inherit version;
    hash = "sha256-zYcAuPVbPAqGpLwRfHozM6RTpH9CkIyjlKi9Jtqp9ug=";
  };

  propagatedBuildInputs = [
    aiohttp
    python-dateutil
    typing-extensions
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
    changelog = "https://github.com/Teekeks/pyTwitchAPI/blob/v${version}/docs/changelog.rst";
    description = "Python implementation of the Twitch Helix API, its Webhook, PubSub and EventSub";
    homepage = "https://github.com/Teekeks/pyTwitchAPI";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda wolfangaukang ];
  };
}
