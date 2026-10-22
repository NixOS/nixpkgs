{
  lib,
  bluetooth-sensor-state-data,
  buildPythonPackage,
  fetchFromGitHub,
  home-assistant-bluetooth,
  poetry-core,
  pytest-cov-stub,
  pytestCheckHook,
  sensor-state-data,
}:

buildPythonPackage rec {
  pname = "tilt-ble";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "tilt-ble";
    tag = "v${version}";
    hash = "sha256-u40xpjwxOdM7FUIPQG9g8q86cZHv21HCxbtnvAAgfgU=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    bluetooth-sensor-state-data
    home-assistant-bluetooth
    sensor-state-data
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tilt_ble" ];

  meta = {
    description = "Library for Tilt BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/tilt-ble";
    changelog = "https://github.com/Bluetooth-Devices/tilt-ble/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
