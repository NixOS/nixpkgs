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
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "danielcherubini";
    repo = "elegoo-homeassistant";
    tag = "v${version}";
    hash = "sha256-AA3unv5dLdkR1yJ6f7YsAfpsOQyQ0696RGAHi4wMdIY=";
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
    # multicast is not available in the nix sandbox
    "custom_components/elegoo_printer/tests/test_config_flow_cc2_options.py::TestManualIpWithProxyHost::test_blank_proxy_host_runs_discovery_as_before"
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
