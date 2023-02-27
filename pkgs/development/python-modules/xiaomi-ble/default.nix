{ lib
, bleak-retry-connector
, bluetooth-data-tools
, bluetooth-sensor-state-data
, buildPythonPackage
, fetchFromGitHub
, home-assistant-bluetooth
, poetry-core
, pycryptodomex
, pytestCheckHook
, pythonOlder
, sensor-state-data
}:

buildPythonPackage rec {
  pname = "xiaomi-ble";
  version = "0.16.4";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ye/BuVKLNSC0zJzDyuairbrmZgQ+sX0y9bHWEfb/MJE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    bleak-retry-connector
    bluetooth-data-tools
    bluetooth-sensor-state-data
    home-assistant-bluetooth
    pycryptodomex
    sensor-state-data
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=xiaomi_ble --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "xiaomi_ble"
  ];

  meta = with lib; {
    description = "Library for Xiaomi BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/xiaomi-ble";
    changelog = "https://github.com/Bluetooth-Devices/xiaomi-ble/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
