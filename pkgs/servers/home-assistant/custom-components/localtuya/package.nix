{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "xZetsubou";
  domain = "localtuya";
  version = "2026.10.0";

  src = fetchFromGitHub {
    owner = "xZetsubou";
    repo = "hass-localtuya";
    tag = finalAttrs.version;
    hash = "sha256-sHbfWwkWGIqx0NMku+jLHsZGuyXoyG8Rj1slw12crDs=";
  };

  meta = {
    changelog = "https://github.com/xZetsubou/hass-localtuya/releases/tag/${finalAttrs.version}";
    description = "Home Assistant custom Integration for local handling of Tuya-based devices, fork from local-tuya";
    homepage = "https://github.com/xZetsubou/hass-localtuya";
    maintainers = with lib.maintainers; [ rhoriguchi ];
    license = lib.licenses.gpl3Only;
  };
})
