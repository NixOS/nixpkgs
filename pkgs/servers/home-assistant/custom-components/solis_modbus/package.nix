{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  pymodbus,
  pytestCheckHook,
  pytest-homeassistant-custom-component,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "Pho3niX90";
  domain = "solis_modbus";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "Pho3niX90";
    repo = "solis_modbus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mJ9v0QwP8SOfZwQW6eXoyOQfg3+Bq9B+th5FE0+Kfco=";
  };

  dependencies = [
    pymodbus
  ];

  nativeCheckInputs = [
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  meta = {
    description = "Home Assistant integration for Solis inverters";
    homepage = "https://github.com/Pho3niX90/solis_modbus";
    changelog = "https://github.com/Pho3niX90/solis_modbus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
