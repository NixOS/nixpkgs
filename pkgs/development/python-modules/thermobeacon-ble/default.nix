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
  pname = "thermobeacon-ble";
  version = "0.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bluetooth-devices";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-WjABxtZ5td25K9QCbLHisT+DMd2Cv/nljwYwxY2br3A=";
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
      --replace " --cov=thermobeacon_ble --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "thermobeacon_ble"
  ];

  meta = with lib; {
    description = "Library for Thermobeacon BLE devices";
    homepage = "https://github.com/bluetooth-devices/thermobeacon-ble";
    changelog = "https://github.com/Bluetooth-Devices/thermobeacon-ble/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
