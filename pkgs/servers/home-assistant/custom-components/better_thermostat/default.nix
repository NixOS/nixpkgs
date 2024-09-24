{
  buildHomeAssistantComponent,
  fetchFromGitHub,
  lib,
}:

buildHomeAssistantComponent rec {
  owner = "KartoffelToby";
  domain = "better_thermostat";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "KartoffelToby";
    repo = "better_thermostat";
    rev = "refs/tags/${version}";
    hash = "sha256-9iwrGKk3/m38ghDVGzKODWo9vzzZxJ91413/KWnULJU=";
  };

  meta = {
    changelog = "https://github.com/KartoffelToby/better_thermostat/releases/tag/${version}";
    description = "Smart TRV control integrates room-temp sensors, window/door sensors, weather forecasts, and ambient probes for efficient heating and calibration, enhancing energy savings and comfort";
    homepage = "https://better-thermostat.org/";
    maintainers = with lib.maintainers; [ mguentner ];
    license = lib.licenses.agpl3Only;
  };
}
