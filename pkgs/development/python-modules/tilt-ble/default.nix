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
  pname = "tilt-ble";
  version = "0.2.3";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PR+BA0wUljUeUYCTRMKxkG+kj6PfklksbO/k9L7sWdE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    bluetooth-sensor-state-data
    home-assistant-bluetooth
    sensor-state-data
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=tilt_ble --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "tilt_ble"
  ];

  meta = with lib; {
    description = "Library for Tilt BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/tilt-ble";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
