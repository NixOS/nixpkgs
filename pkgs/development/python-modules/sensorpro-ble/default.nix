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
  pname = "sensorpro-ble";
  version = "0.5.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "sensorpro-ble";
    rev = "refs/tags/v${version}";
    hash = "sha256-Zqa6qa0Jw79Iu4VEw6KN0GsZcC1X7OpiYUiyT4zwKyY=";
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

  pythonImportsCheck = [ "sensorpro_ble" ];

  meta = with lib; {
    description = "Library for Sensorpro BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/sensorpro-ble";
    changelog = "https://github.com/Bluetooth-Devices/sensorpro-ble/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
