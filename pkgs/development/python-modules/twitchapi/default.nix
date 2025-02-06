{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  python-dateutil,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "twitchapi";
  version = "4.4.0";

  disabled = pythonOlder "3.7";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "Teekeks";
    repo = "pyTwitchAPI";
    tag = "v${version}";
    hash = "sha256-yN7KsiPnhGSm8wj44zn1TzGhRDIMflkKiRnBlVT5i2o=";
  };

  postPatch = ''
    sed -i "/document_enum/d" twitchAPI/type.py
  '';

  pythonRemoveDeps = [
    "enum-tools"
  ];

  build-system = [ setuptools ];

  dependencies = [
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
    "twitchAPI.type"
  ];

  meta = with lib; {
    changelog = "https://github.com/Teekeks/pyTwitchAPI/blob/${src.rev}/docs/changelog.rst";
    description = "Python implementation of the Twitch Helix API, its Webhook, PubSub and EventSub";
    homepage = "https://github.com/Teekeks/pyTwitchAPI";
    license = licenses.mit;
    maintainers = with maintainers; [
      dotlambda
    ];
  };
}
