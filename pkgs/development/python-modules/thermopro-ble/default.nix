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
  pythonOlder,
  sensor-state-data,
}:

buildPythonPackage rec {
  pname = "thermopro-ble";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bluetooth-devices";
    repo = "thermopro-ble";
    tag = "v${version}";
    hash = "sha256-m4koagyGOOuwFCctQK1oz5riwCbrC0I8js+bnrHxwMY=";
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

  meta = with lib; {
    description = "Library for Thermopro BLE devices";
    homepage = "https://github.com/bluetooth-devices/thermopro-ble";
    changelog = "https://github.com/Bluetooth-Devices/thermopro-ble/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
