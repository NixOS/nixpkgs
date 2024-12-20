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
  pname = "thermopro-ble";
  version = "0.10.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bluetooth-devices";
    repo = "thermopro-ble";
    rev = "refs/tags/v${version}";
    hash = "sha256-xaRbp9XLCDGJ0NE0TzJygn2OzqvSFszs97vGHawCkzU=";
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

  pythonImportsCheck = [ "thermopro_ble" ];

  meta = with lib; {
    description = "Library for Thermopro BLE devices";
    homepage = "https://github.com/bluetooth-devices/thermopro-ble";
    changelog = "https://github.com/Bluetooth-Devices/thermopro-ble/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
