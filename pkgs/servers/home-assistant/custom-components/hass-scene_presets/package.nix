{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:

buildHomeAssistantComponent rec {
  owner = "Hypfer";
  domain = "scene_presets";
  version = "2.2.5";

  src = fetchFromGitHub {
    owner = "Hypfer";
    repo = "hass-scene_presets";
    tag = "${version}";
    hash = "sha256-cjiKwY3UPPZxDWlFQmTGwnUWaX4StMfZD4Hqm8/Sr84=";
  };

  patches = [
    ./disable-custom-presets.diff
  ];

  meta = {
    changelog = "https://github.com/Hypfer/hass-scene_presets/releases/tag/${src.tag}";
    description = "Hue-like scene presets for lights in Home Assistant";
    homepage = "https://github.com/Hypfer/hass-scene_presets";
    maintainers = with lib.maintainers; [ jpds ];
    license = lib.licenses.asl20;
  };
}
