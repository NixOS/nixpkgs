{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  nix-update-script,
}:

buildHomeAssistantComponent rec {
  owner = "Hypfer";
  domain = "scene_presets";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "Hypfer";
    repo = "hass-scene_presets";
    tag = version;
    hash = "sha256-ESu7+65IeXYZLLqlkRlJA7+Ggo+X+YoWcpmMQiNzOTM=";
  };

  postInstall = ''
    mkdir -p "$out/custom_components/scene_presets/userdata/custom/assets"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/Hypfer/hass-scene_presets/releases/tag/${src.tag}";
    description = "Hue-like scene presets for lights in Home Assistant";
    homepage = "https://github.com/Hypfer/hass-scene_presets";
    maintainers = with lib.maintainers; [ jpds ];
    license = lib.licenses.asl20;
  };
}
