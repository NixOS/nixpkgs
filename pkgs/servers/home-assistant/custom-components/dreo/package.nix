{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  nix-update-script,
  websockets,
  # Test dependencies
  pytest9_0CheckHook,
  pytest-homeassistant-custom-component,
}:

buildHomeAssistantComponent rec {
  owner = "JeffSteinbok";
  domain = "dreo";
  version = "1.11.1";

  src = fetchFromGitHub {
    inherit owner;
    repo = "hass-dreo";
    tag = "v${version}";
    hash = "sha256-D9UOFEyWWj5zkgv5MxE8baYKajq7uGXcC6HVC0MaOvw=";
  };

  dependencies = [ websockets ];

  nativeCheckInputs = [
    pytest-homeassistant-custom-component
    pytest9_0CheckHook
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
