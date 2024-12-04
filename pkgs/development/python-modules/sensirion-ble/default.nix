{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  bluetooth-data-tools,
  bluetooth-sensor-state-data,
  home-assistant-bluetooth,
  sensor-state-data,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "sensirion-ble";
  version = "0.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "akx";
    repo = "sensirion-ble";
    rev = "refs/tags/v${version}";
    hash = "sha256-VeUfrQ/1Hqs9yueUKcv/ZpCDEEy84VDcZpuTT4fXSGw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=sensirion_ble --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    bluetooth-data-tools
    bluetooth-sensor-state-data
    home-assistant-bluetooth
    sensor-state-data
  ];

  pythonImportsCheck = [ "sensirion_ble" ];

  meta = with lib; {
    description = "Parser for Sensirion BLE devices";
    homepage = "https://github.com/akx/sensirion-ble";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
