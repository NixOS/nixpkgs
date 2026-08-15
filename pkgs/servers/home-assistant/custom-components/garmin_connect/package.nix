{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  ha-garmin,
}:

buildHomeAssistantComponent rec {
  owner = "cyberjunky";
  domain = "garmin_connect";
  version = "3.0.15";

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "home-assistant-garmin_connect";
    tag = version;
    hash = "sha256-hX+8rUhDFIpnd3l1sproYxuASPxMw3haRHphywUPC24=";
  };

  dependencies = [
    ha-garmin
  ];

  # home-assistant-garmin_connect pins an exact version of ha-garmin, but we
  # want to allow newer, compatible versions to be used.
  ignoreVersionRequirement = [ "ha-garmin" ];

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
