{
  lib,
  async-timeout,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  pytest-freezer,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
}:

buildHomeAssistantComponent rec {
  owner = "olen";
  domain = "plant";
  version = "2026.8.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "homeassistant-plant";
    tag = "v${version}";
    hash = "sha256-2u+0Ufpg22Ad+TRT4pUzzEdwSpKASotww/tun38e4AA=";
  };

  dependencies = [
    async-timeout
  ];

  nativeCheckInputs = [
    pytest-freezer
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  disabledTestPaths = [
    # pytest_homeassistant_custom_component wants to write into its nix store path
    "tests/test_conditions.py"
    "tests/test_triggers.py"
  ];

  meta = {
    description = "Alternative Plant component of home assistant";
    homepage = "https://github.com/Olen/homeassistant-plant";
    changelog = "https://github.com/Olen/homeassistant-plant/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.mit;
  };
}
