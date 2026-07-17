{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  gtfs-station-stop,
  pytest-cov-stub,
  pytest-freezer,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
}:

buildHomeAssistantComponent rec {
  owner = "bcpearce";
  domain = "gtfs_realtime";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "bcpearce";
    repo = "homeassistant-gtfs-realtime";
    tag = version;
    hash = "sha256-rf11yej0IsB3Og5D4n4iAsehWODJcjC930RzcGCsIT4=";
  };

  dependencies = [ gtfs-station-stop ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-freezer
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  disabledTests = [
    # upstream snapshot is stale
    "test_diagnostics"
  ];

  ignoreVersionRequirement = [ "gtfs_station_stop" ];

  meta = {
    changelog = "https://github.com/bcpearce/homeassistant-gtfs-realtime/releases/tag/${src.tag}";
    description = "GTFS Realtime transit arrivals for Home Assistant";
    homepage = "https://github.com/bcpearce/homeassistant-gtfs-realtime";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.stepbrobd ];
  };
}
