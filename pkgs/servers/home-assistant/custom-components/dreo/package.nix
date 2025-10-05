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
  version = "1.3.3";

  src = fetchFromGitHub {
    inherit owner;
    repo = "hass-dreo";
    tag = "v${version}";
    hash = "sha256-eAgqjAXNAY8kr7+49q+tikW3bDBJ0N0Rh5WJwzLYr8I=";
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
