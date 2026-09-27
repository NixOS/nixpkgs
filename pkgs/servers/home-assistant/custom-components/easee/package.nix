{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  pyeasee,
}:

buildHomeAssistantComponent rec {
  owner = "nordicopen";
  domain = "easee";
  version = "0.9.71";

  src = fetchFromGitHub {
    owner = "nordicopen";
    repo = "easee_hass";
    tag = "v${version}";
    hash = "sha256-OgHr1MqE4OthtnQrLo6jhZhmE+4x5rAkZQ8bEwMdHrM=";
  };

  dependencies = [
    pyeasee
  ];

  meta = {
    description = "Custom component for Easee EV charger integration with Home Assistant";
    homepage = "https://github.com/nordicopen/easee_hass";
    changelog = "https://github.com/nordicopen/easee_hass/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dandellion ];
  };
}
