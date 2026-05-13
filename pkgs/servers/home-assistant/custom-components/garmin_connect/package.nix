{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  ha-garmin,
}:

buildHomeAssistantComponent rec {
  owner = "cyberjunky";
  domain = "garmin_connect";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "home-assistant-garmin_connect";
    tag = version;
    hash = "sha256-omHgfkrje5xR9gLnQpAz33+LtXm5eGJ8nERYBX4F2sY=";
  };

  dependencies = [
    ha-garmin
  ];

  meta = {
    changelog = "https://github.com/cyberjunky/home-assistant-garmin_connect/releases/tag/${src.tag}";
    description = "Garmin Connect integration allows you to expose data from Garmin Connect to Home Assistant";
    homepage = "https://github.com/cyberjunky/home-assistant-garmin_connect";
    maintainers = with lib.maintainers; [
      matthiasbeyer
      dmadisetti
    ];
    license = lib.licenses.mit;
  };
}
