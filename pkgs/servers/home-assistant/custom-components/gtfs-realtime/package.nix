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
  version = "0.4.10";

  src = fetchFromGitHub {
    owner = "bcpearce";
    repo = "homeassistant-gtfs-realtime";
    tag = version;
    hash = "sha256-XKQsHN9gnVrRT+SFJMPU+qO2KCApgmkDB1PKW2PJeNg=";
  };

  dependencies = [ gtfs-station-stop ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-freezer
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  disabledTests = [
    # calls async_get_device with deprecated via_device=
    "test_call_card_creator"
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
