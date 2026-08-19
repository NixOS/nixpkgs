{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "thomasloven";
  domain = "custom_icons";
  version = "1.0.2";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "hass-custom_icons";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RJ9lfEFzKIFacOkOBlpS+7YJjHFxxRNmOQtIxt0Z8ks=";
  };

  meta = {
    description = "Home Assistant custom component for loading custom SVG icons";
    homepage = "https://github.com/thomasloven/hass-custom_icons";
    changelog = "https://github.com/thomasloven/hass-custom_icons/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Masrepus ];
  };
})
