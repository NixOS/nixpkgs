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
  pytestCheckHook,
  aiohttp,
  home-assistant,
}:

buildHomeAssistantComponent rec {
  owner = "danielcherubini";
  domain = "elegoo_printer";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "danielcherubini";
    repo = "elegoo-homeassistant";
    tag = "v${version}";
    hash = "sha256-aeptx8CFKD+22H8Bw19rDUuHkET3vINN3NpGuherc8Y=";
  };

  dependencies = [
    aiomqtt
    colorlog
    loguru
    websocket-client
    websockets
  ];

  nativeCheckInputs = [
    pytestCheckHook
    aiohttp
    home-assistant
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
