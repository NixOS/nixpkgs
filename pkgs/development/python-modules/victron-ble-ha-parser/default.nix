{
  lib,
  bluetooth-sensor-state-data,
  buildPythonPackage,
  fetchFromGitHub,
  sensor-state-data,
  setuptools,
  victron-ble,
}:

buildPythonPackage rec {
  pname = "victron-ble-ha-parser";
  version = "0.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rajlaud";
    repo = "victron-ble-ha-parser";
    tag = "v${version}";
    hash = "sha256-wSkTIX1TTP2geU7bgsdJj6Nv5SIGgd6k84G7tRCo3O0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bluetooth-sensor-state-data
    sensor-state-data
    victron-ble
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "victron_ble_ha_parser" ];

  meta = {
    description = "Parser for Victron BLE messages suitable for use with Home Assistant";
    homepage = "https://github.com/rajlaud/victron-ble-ha-parser";
    changelog = "https://github.com/rajlaud/victron-ble-ha-parser/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
