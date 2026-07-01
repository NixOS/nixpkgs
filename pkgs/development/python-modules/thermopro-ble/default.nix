{
  lib,
  bluetooth-data-tools,
  bluetooth-sensor-state-data,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  sensor-state-data,
}:

buildPythonPackage (finalAttrs: {
  pname = "thermopro-ble";
  version = "1.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bluetooth-devices";
    repo = "thermopro-ble";
    tag = "v${finalAttrs.version}";
    hash = "sha256-goTJwTMaWBm5gc0/LOkjpKeRTkLStHkKJYsbE5Wj/X4=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    bluetooth-data-tools
    bluetooth-sensor-state-data
    sensor-state-data
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "thermopro_ble" ];

  meta = {
    description = "Library for Thermopro BLE devices";
    homepage = "https://github.com/bluetooth-devices/thermopro-ble";
    changelog = "https://github.com/Bluetooth-Devices/thermopro-ble/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
