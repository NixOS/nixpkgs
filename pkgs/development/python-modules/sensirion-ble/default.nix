{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, bluetooth-data-tools
, bluetooth-sensor-state-data
, home-assistant-bluetooth
, sensor-state-data
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sensirion-ble";
  version = "0.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "akx";
    repo = "sensirion-ble";
    rev = "refs/tags/v${version}";
    hash = "sha256-7l76/Bci1ztt2CfwytLOySK6IL8IDijpB0AYhksRP7o=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=sensirion_ble --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    bluetooth-data-tools
    bluetooth-sensor-state-data
    home-assistant-bluetooth
    sensor-state-data
  ];

  pythonImportsCheck = [
    "sensirion_ble"
  ];

  meta = with lib; {
    description = "Parser for Sensirion BLE devices";
    homepage = "https://github.com/akx/sensirion-ble";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
