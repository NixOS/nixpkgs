{
  lib,
  pymodbus,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  async-timeout,
  aiohttp,
  websocket-client,
  beautifulsoup4,
  pytestCheckHook,
  pytest-homeassistant-custom-component,
}:

buildHomeAssistantComponent rec {
  owner = "AN3Orik";
  domain = "systemair";
  version = "1.0.29";

  src = fetchFromGitHub {
    inherit owner;
    repo = "systemair";
    tag = "v${version}";
    hash = "sha256-qpwF1HZZ8pEDywkFij9ipF3BPFe3oAj8wQKILNuKoHc=";
  };

  ignoreVersionRequirement = [
    "pymodbus"
  ];

  dependencies = [
    pymodbus
    async-timeout
    aiohttp
    websocket-client
    beautifulsoup4
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-homeassistant-custom-component
  ];

  pytestFlags = [
    "-Wignore::pytest.PytestRemovedIn9Warning"
  ];

  meta = {
    changelog = "https://github.com/AN3Orik/systemair/releases/tag/v${version}";
    description = "Home Assistant component for Systemair SAVE ventilation units";
    homepage = "https://github.com/AN3Orik/systemair";
    maintainers = with lib.maintainers; [ uvnikita ];
    license = lib.licenses.mit;
  };
}
