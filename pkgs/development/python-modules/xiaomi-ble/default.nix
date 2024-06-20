{
  lib,
  bleak,
  bleak-retry-connector,
  bluetooth-data-tools,
  bluetooth-sensor-state-data,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  home-assistant-bluetooth,
  poetry-core,
  pycryptodomex,
  pytestCheckHook,
  pythonOlder,
  pythonRelaxDepsHook,
  sensor-state-data,
}:

buildPythonPackage rec {
  pname = "xiaomi-ble";
  version = "0.30.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "xiaomi-ble";
    rev = "refs/tags/v${version}";
    hash = "sha256-pWTWzw1ZdXnxPERkJUHumBboSIVo0t5HqQFRXC90CpU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --cov=xiaomi_ble --cov-report=term-missing:skip-covered" ""
  '';

  build-system = [ poetry-core ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRelaxDeps = [ "pycryptodomex" ];

  dependencies = [
    bleak
    bleak-retry-connector
    bluetooth-data-tools
    bluetooth-sensor-state-data
    cryptography
    home-assistant-bluetooth
    pycryptodomex
    sensor-state-data
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "xiaomi_ble" ];

  meta = with lib; {
    description = "Library for Xiaomi BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/xiaomi-ble";
    changelog = "https://github.com/Bluetooth-Devices/xiaomi-ble/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
