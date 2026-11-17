{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  modbus-connection,
  pymodbus,
  pytestCheckHook,
  pytest-homeassistant-custom-component,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "Pho3niX90";
  domain = "solis_modbus";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "Pho3niX90";
    repo = "solis_modbus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BsmImf4OWRLnOKB4w0LU3bgayKiRSO3rLR/CAXs5Fq0=";
  };

  dependencies = [
    modbus-connection
    pymodbus
  ]
  ++ modbus-connection.optional-dependencies.tmodbus;

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
