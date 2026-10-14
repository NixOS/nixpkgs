{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  pymodbus,
  pyyaml,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "anker-charging";
  domain = "anker_solix_official";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "anker-charging";
    repo = "ha-anker-solix-official";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zYjC4z+IMUgOfwmpWAqmmUyMDeS9IqchNAtg4EPo1wQ=";
  };

  dependencies = [
    pymodbus
    pyyaml
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/anker-charging/ha-anker-solix-official/issues/115
    "test_uses_new_api_when_available_with_both_required_args"
    "test_falls_back_to_deprecated_api_when_new_api_absent"
    # pytest_homeassistant_custom_component.plugins.HASocketBlockedError: A test tried to use socket.socket.
    "test_creates_client_lazily_when_none"
  ];

  meta = {
    description = "Official Home Assistant integration for Anker Solix devices via local Modbus TCP";
    homepage = "https://github.com/anker-charging/ha-anker-solix-official";
    changelog = "https://github.com/anker-charging/ha-anker-solix-official/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
