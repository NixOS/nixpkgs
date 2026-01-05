{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "sensor-state-data";
  version = "2.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "sensor-state-data";
    tag = "v${version}";
    hash = "sha256-ONAM1WxKnzRCJsuJa+4zDaOXPkTj+zcTH54SgktpMR8=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "sensor_state_data" ];

  meta = with lib; {
    description = "Models for storing and converting Sensor Data state";
    homepage = "https://github.com/bluetooth-devices/sensor-state-data";
    changelog = "https://github.com/Bluetooth-Devices/sensor-state-data/releases/tag/${src.tag}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
