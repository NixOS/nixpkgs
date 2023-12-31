{ lib
, bluetooth-data-tools
, bluetooth-sensor-state-data
, buildPythonPackage
, fetchFromGitHub
, home-assistant-bluetooth
, poetry-core
, pytestCheckHook
, pythonOlder
, sensor-state-data
}:

buildPythonPackage rec {
  pname = "sensorpush-ble";
  version = "1.6.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "sensorpush-ble";
    rev = "refs/tags/v${version}";
    hash = "sha256-g0UFEkTPpKqx5+hrM+bM6iQrG8EaMcFN01JdHEVH9VQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=sensorpush_ble --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    bluetooth-data-tools
    bluetooth-sensor-state-data
    home-assistant-bluetooth
    sensor-state-data
  ];

  nativeCheckInputs = [
    pytestCheckHook  ];


  pythonImportsCheck = [
    "sensorpush_ble"
  ];

  meta = with lib; {
    description = "Library for SensorPush BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/sensorpush-ble";
    changelog = "https://github.com/Bluetooth-Devices/sensorpush-ble/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
