{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  fetchNpmDeps,
  nix-update-script,
  nodejs,
  npmHooks,
}:

buildHomeAssistantComponent rec {
  owner = "Hypfer";
  domain = "scene_presets";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "Hypfer";
    repo = "hass-scene_presets";
    tag = version;
    hash = "sha256-pHY68H0nr7eO3tGtVLtzj6cOZO3+VxC00VZmhZy+2Pk=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-HgUf0BHUOOS2LIodPeJK0tZ9HwwLwMtYlaE1dvBtkFo=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    npmHooks.npmBuildHook
  ];

  npmBuildScript = "build";

  postInstall = ''
    # Create custom presets directory to satisfy Python set-up code
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
