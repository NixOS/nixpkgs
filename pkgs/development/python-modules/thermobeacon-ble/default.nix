{
  lib,
  bluetooth-data-tools,
  bluetooth-sensor-state-data,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  sensor-state-data,
}:

buildPythonPackage rec {
  pname = "thermobeacon-ble";
  version = "0.8.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bluetooth-devices";
    repo = "thermobeacon-ble";
    tag = "v${version}";
    hash = "sha256-kyhLj72WzQ4LpPbW38OWlb1YQs5R+R9Fb3sBYqRkY2M=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    bluetooth-data-tools
    bluetooth-sensor-state-data
    sensor-state-data
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "thermobeacon_ble" ];

  meta = with lib; {
    description = "Library for Thermobeacon BLE devices";
    homepage = "https://github.com/bluetooth-devices/thermobeacon-ble";
    changelog = "https://github.com/Bluetooth-Devices/thermobeacon-ble/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
