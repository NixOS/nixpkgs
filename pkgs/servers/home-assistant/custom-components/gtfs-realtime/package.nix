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
  version = "0.4.9";

  src = fetchFromGitHub {
    owner = "bcpearce";
    repo = "homeassistant-gtfs-realtime";
    tag = version;
    hash = "sha256-a9ZL5NQvmMi58rfTG3REDpYAkg8Y4PmeYn/brBz5K3U=";
  };

  dependencies = [ gtfs-station-stop ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-freezer
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  pytestFlags = [
    # delete unused snapshots in 0.4.8 release
    "--snapshot-update"
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
