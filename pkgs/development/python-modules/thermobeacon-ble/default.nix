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
  version = "0.3.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bluetooth-devices";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OvSvhOcJSThKyLXHhiwEZtCrYt6+KB5iArUKjfoi2OI=";
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
