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
  version = "0.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-D0xHNPsGlNBoHR3LqR6TbVhqXWapzwYsG+uN3kSF1oE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    bluetooth-data-tools
    bluetooth-sensor-state-data
    sensor-state-data
  ];

  nativeCheckInputs = [
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
    changelog = "https://github.com/Bluetooth-Devices/sensorpro-ble/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
