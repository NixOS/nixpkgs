{
  lib,
  bluetooth-data-tools,
  bluetooth-sensor-state-data,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  home-assistant-bluetooth,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  sensor-state-data,
}:

buildPythonPackage rec {
  pname = "sensirion-ble";
  version = "0.1.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "akx";
    repo = "sensirion-ble";
    tag = "v${version}";
    hash = "sha256-VeUfrQ/1Hqs9yueUKcv/ZpCDEEy84VDcZpuTT4fXSGw=";
  };

  build-system = [ hatchling ];

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

  pythonImportsCheck = [ "sensirion_ble" ];

  meta = with lib; {
    description = "Parser for Sensirion BLE devices";
    homepage = "https://github.com/akx/sensirion-ble";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
