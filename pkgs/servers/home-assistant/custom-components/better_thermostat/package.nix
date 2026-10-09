{
  buildHomeAssistantComponent,
  fetchFromGitHub,
  lib,
  gitUpdater,
  numpy,
}:

buildHomeAssistantComponent rec {
  owner = "KartoffelToby";
  domain = "better_thermostat";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "KartoffelToby";
    repo = "better_thermostat";
    tag = version;
    hash = "sha256-AXu9VUHwmy1lrSfrP6rmf0xS536gNmG7ou60MLhfKkE=";
  };

  dependencies = [
    numpy
  ];

  passthru.updateScript = gitUpdater {
    ignoredVersions = "(Alpha|Beta|alpha|beta).*";
  };

  meta = {
    changelog = "https://github.com/KartoffelToby/better_thermostat/releases/tag/${version}";
    description = "Smart TRV control integrates room-temp sensors, window/door sensors, weather forecasts, and ambient probes for efficient heating and calibration, enhancing energy savings and comfort";
    homepage = "https://better-thermostat.org/";
    maintainers = with lib.maintainers; [ mguentner ];
    license = lib.licenses.agpl3Only;
  };
}
