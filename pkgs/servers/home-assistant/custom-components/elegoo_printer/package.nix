{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,

  # dependencies
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
  version = "2.3.5";

  src = fetchFromGitHub {
    owner = "danielcherubini";
    repo = "elegoo-homeassistant";
    tag = "v${version}";
    hash = "sha256-Ekt19lfn0DdedMFhJDDUkqsv7vjS96+lAhWveag6EeE=";
  };

  dependencies = [
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

  meta = with lib; {
    changelog = "https://github.com/danielcherubini/elegoo-homeassistant/releases/tag/v${version}";
    description = "Home Assistant integration for Elegoo 3D printers using the SDCP protocol";
    homepage = "https://github.com/danielcherubini/elegoo-homeassistant";
    license = licenses.mit;
    maintainers = with maintainers; [
      typedrat
    ];
  };
}
