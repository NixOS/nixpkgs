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
  version = "1.11.2";

  src = fetchFromGitHub {
    inherit owner;
    repo = "hass-dreo";
    tag = "v${version}";
    hash = "sha256-OY8VFBZXCKgluJB3k/fXrDtEv17xu7Qw6dVQh4RgUAU=";
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
