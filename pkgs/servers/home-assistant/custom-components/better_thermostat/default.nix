{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:

buildHomeAssistantComponent rec {
  owner = "KartoffelToby";
  domain = "better_thermostat";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "KartoffelToby";
    repo = "better_thermostat";
    rev = "refs/tags/${version}";
    hash = "sha256-noo96Uks+MHtTbwIoU5gnekp/IwMry0U18X4I1qe4LQ=";
  };

  meta = with lib; {
    changelog = "https://github.com/KartoffelToby/better_thermostat/releases/tag/${version}";
    description = "Smart TRV control integrates room-temp sensors, window/door sensors, weather forecasts, and ambient probes for efficient heating and calibration, enhancing energy savings and comfort.";
    homepage = "https://better-thermostat.org/";
    maintainers = with maintainers; [ mguentner ];
    license = licenses.agpl3Only;
  };
}
