{
  lib,
  bluetooth-data-tools,
  bluetooth-sensor-state-data,
  buildPythonPackage,
  fetchFromGitHub,
  home-assistant-bluetooth,
  poetry-core,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  sensor-state-data,
}:

buildPythonPackage rec {
  pname = "sensorpush-ble";
  version = "1.7.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "sensorpush-ble";
    rev = "refs/tags/v${version}";
    hash = "sha256-T2sjzQoWWRGAKiMDN29jZ7jZ5/i75qpNCiuVB7VEhJw=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    bluetooth-data-tools
    bluetooth-sensor-state-data
    home-assistant-bluetooth
    sensor-state-data
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sensorpush_ble" ];

  meta = with lib; {
    description = "Library for SensorPush BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/sensorpush-ble";
    changelog = "https://github.com/Bluetooth-Devices/sensorpush-ble/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
