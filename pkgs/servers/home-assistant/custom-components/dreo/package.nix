{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  nix-update-script,
  websockets,
  # Test dependencies
  pytestCheckHook,
  pytest-homeassistant-custom-component,
}:

buildHomeAssistantComponent rec {
  owner = "JeffSteinbok";
  domain = "dreo";
  version = "1.5.3";

  src = fetchFromGitHub {
    inherit owner;
    repo = "hass-dreo";
    tag = "v${version}";
    hash = "sha256-hUHgf04RY7RQ4KzwSoFL9MT8a80+g3VGWbgisGDzRYA=";
  };

  dependencies = [ websockets ];

  nativeCheckInputs = [
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/JeffSteinbok/hass-dreo/releases/tag/${src.tag}";
    description = "Dreo Smart Device Integration for Home Assistant";
    homepage = "https://github.com/JeffSteinbok/hass-dreo";
    maintainers = with lib.maintainers; [ CodedNil ];
    license = lib.licenses.mit;
  };
}
