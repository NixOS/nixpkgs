{ lib
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
  version = "1.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2Q56fXMgw1Al3l6WKI1cdGXfLmZ1qkidkoWKmvEXRaI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    bluetooth-sensor-state-data
    home-assistant-bluetooth
    sensor-state-data
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=sensorpush_ble --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "sensorpush_ble"
  ];

  meta = with lib; {
    description = "Library for SensorPush BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/sensorpush-ble";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
