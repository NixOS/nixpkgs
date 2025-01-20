{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  pyeasee,
}:

buildHomeAssistantComponent rec {
  owner = "nordicopen";
  domain = "easee";
  version = "0.9.67";

  src = fetchFromGitHub {
    owner = "nordicopen";
    repo = "easee_hass";
    tag = "v${version}";
    hash = "sha256-psRr3cJ/sK/Z0dgB27GbW0qAHH2vJt+TdxqDB+Zhkc0=";
  };

  dependencies = [
    pyeasee
  ];

  meta = {
    description = "Custom component for Easee EV charger integration with Home Assistant";
    homepage = "https://github.com/nordicopen/easee_hass";
    changelog = "https://github.com/nordicopen/easee_hass/releases/tag/v${version}";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ dandellion ];
  };
}
