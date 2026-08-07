{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  nix-update-script,
}:

buildHomeAssistantComponent rec {
  owner = "claytonjn";
  domain = "circadian_lighting";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "claytonjn";
    repo = "hass-circadian_lighting";
    tag = version;
    hash = "sha256-6S1wIO6UgPdUPt9oDCzIb4duUOql4KgnTd6MjRhrSb0=";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/claytonjn/hass-circadian_lighting/releases/tag/${src.tag}";
    description = "Circadian Lighting custom component for Home Assistant";
    homepage = "https://github.com/claytonjn/hass-circadian_lighting";
    maintainers = with lib.maintainers; [ jpds ];
    license = lib.licenses.asl20;
  };
}
