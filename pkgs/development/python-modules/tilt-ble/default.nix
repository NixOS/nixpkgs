{
  lib,
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
  pname = "tilt-ble";
  version = "0.2.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "tilt-ble";
    rev = "refs/tags/v${version}";
    hash = "sha256-ok9XWx47hcke535480NORfS1pSagaOJvMR48lYTa/Tg=";
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

  meta = with lib; {
    description = "Library for Tilt BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/tilt-ble";
    changelog = "https://github.com/Bluetooth-Devices/tilt-ble/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
