{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  garminconnect,
  tzlocal,
}:

buildHomeAssistantComponent rec {
  owner = "cyberjunky";
  domain = "garmin_connect";
  version = "0.2.37";

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "home-assistant-garmin_connect";
    tag = version;
    hash = "sha256-d6RbDplrdqvFGSDcTgoYzYLSHDYdXG3/XvFxj8IfSbY=";
  };

  dependencies = [
    garminconnect
    tzlocal
  ];

  meta = with lib; {
    changelog = "https://github.com/cyberjunky/home-assistant-garmin_connect/releases/tag/${src.tag}";
    description = "Garmin Connect integration allows you to expose data from Garmin Connect to Home Assistant";
    homepage = "https://github.com/cyberjunky/home-assistant-garmin_connect";
    maintainers = with maintainers; [
      matthiasbeyer
      dmadisetti
    ];
    license = licenses.mit;
  };
}
