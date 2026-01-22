{
  lib,
  bleak-retry-connector,
  bleak,
  bluetooth-data-tools,
  bluetooth-sensor-state-data,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  home-assistant-bluetooth,
  orjson,
  poetry-core,
  pycryptodomex,
  pytest-cov-stub,
  pytestCheckHook,
  sensor-state-data,
}:

buildPythonPackage (finalAttrs: {
  pname = "xiaomi-ble";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "xiaomi-ble";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BSWZCugyBnyan4Hl5RxY9IhyGwELl47EQiMrHjjUTKk=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "pycryptodomex" ];

  dependencies = [
    bleak
    bleak-retry-connector
    bluetooth-data-tools
    bluetooth-sensor-state-data
    cryptography
    home-assistant-bluetooth
    orjson
    pycryptodomex
    sensor-state-data
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "xiaomi_ble" ];

  meta = {
    description = "Library for Xiaomi BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/xiaomi-ble";
    changelog = "https://github.com/Bluetooth-Devices/xiaomi-ble/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
