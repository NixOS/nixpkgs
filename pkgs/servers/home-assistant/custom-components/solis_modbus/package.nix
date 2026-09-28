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
  version = "4.2.6";

  src = fetchFromGitHub {
    owner = "Pho3niX90";
    repo = "solis_modbus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M8ECmFdujnlSVVWckdTEwDAWFFl9yzbTIqK9hMxClpk=";
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
