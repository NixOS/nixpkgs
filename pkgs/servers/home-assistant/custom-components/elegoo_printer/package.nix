{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,

  # dependencies
  aiomqtt,
  colorlog,
  loguru,
  websocket-client,
  websockets,

  # tests
  pytest-asyncio,
  pytestCheckHook,
  aiohttp,
  home-assistant,
}:

buildHomeAssistantComponent rec {
  owner = "danielcherubini";
  domain = "elegoo_printer";
  version = "2.13.1";

  src = fetchFromGitHub {
    owner = "danielcherubini";
    repo = "elegoo-homeassistant";
    tag = "v${version}";
    hash = "sha256-L3oFUCqxkygiwTTeHR9MMneA5q4+YFHBoNAxqbqp/Sk=";
  };

  dependencies = [
    aiomqtt
    colorlog
    loguru
    websocket-client
    websockets
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    aiohttp
    home-assistant
  ];

  disabledTestPaths = [
    # https://github.com/danielcherubini/elegoo-homeassistant/issues/419
    "custom_components/elegoo_printer/tests/test_coordinator.py"
  ];

  meta = {
    changelog = "https://github.com/danielcherubini/elegoo-homeassistant/releases/tag/v${version}";
    description = "Home Assistant integration for Elegoo 3D printers using the SDCP protocol";
    homepage = "https://github.com/danielcherubini/elegoo-homeassistant";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      typedrat
    ];
  };
}
