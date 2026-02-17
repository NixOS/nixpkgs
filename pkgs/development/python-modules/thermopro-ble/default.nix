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

buildPythonPackage rec {
  pname = "thermopro-ble";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bluetooth-devices";
    repo = "thermopro-ble";
    tag = "v${version}";
    hash = "sha256-LyFA/O7nsmbg8KxT07Z0l+GEnTWF/IG0ykIN/8FK8Es=";
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
    changelog = "https://github.com/Bluetooth-Devices/thermopro-ble/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
