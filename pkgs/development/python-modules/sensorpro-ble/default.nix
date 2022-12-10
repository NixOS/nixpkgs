{ lib
, bluetooth-data-tools
, bluetooth-sensor-state-data
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, sensor-state-data
}:

buildPythonPackage rec {
  pname = "sensorpro-ble";
  version = "0.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-B5WtOl1Va2rqm6PZEUCYakN7mE2zz/edGj+TtwDcS+Y=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    bluetooth-data-tools
    bluetooth-sensor-state-data
    sensor-state-data
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=sensorpro_ble --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "sensorpro_ble"
  ];

  meta = with lib; {
    description = "Library for Sensorpro BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/sensorpro-ble";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
