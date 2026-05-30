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
  version = "1.9.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "hass-dreo";
    tag = "v${version}";
    hash = "sha256-JF1n6a33qA6HN0JQ5ULT87Pnj3tp7ZrIwLfhLrWx+6I=";
  };

  dependencies = [ websockets ];

  nativeCheckInputs = [
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  pytestFlags = [
    "-Wignore::pytest.PytestRemovedIn9Warning"
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
