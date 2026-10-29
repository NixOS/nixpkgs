{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  nix-update-script,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "claytonjn";
  domain = "circadian_lighting";
  version = "2.1.7";

  src = fetchFromGitHub {
    owner = "claytonjn";
    repo = "hass-circadian_lighting";
    tag = finalAttrs.version;
    hash = "sha256-tFwlnZWfsxvVcG9VJklSgwHFwDM1ZIai60AStoB+Pus=";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/claytonjn/hass-circadian_lighting/releases/tag/${finalAttrs.src.tag}";
    description = "Circadian Lighting custom component for Home Assistant";
    homepage = "https://github.com/claytonjn/hass-circadian_lighting";
    maintainers = with lib.maintainers; [ jpds ];
    license = lib.licenses.asl20;
  };
})
