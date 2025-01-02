{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  async-timeout,
  music-assistant-client,
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-homeassistant-custom-component,
  zeroconf,
}:

buildHomeAssistantComponent rec {
  owner = "music-assistant";
  domain = "mass";
  version = "2024.12.1";

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "hass-music-assistant";
    rev = version;
    hash = "sha256-e2e59oG0PeQdq/Vg4ovjxpOQTXrDfQxFVkWZ63QkfRw=";
  };

  dependencies = [
    async-timeout
    music-assistant-client
  ];

  ignoreVersionRequirement = [ "music-assistant-client" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
    pytest-homeassistant-custom-component
    zeroconf
  ];

  meta = with lib; {
    description = "Turn your Home Assistant instance into a jukebox, hassle free streaming of your favorite media to Home Assistant media players";
    homepage = "https://github.com/music-assistant/hass-music-assistant";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
