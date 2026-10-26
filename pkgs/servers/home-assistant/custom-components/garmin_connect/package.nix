{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  ha-garmin,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "cyberjunky";
  domain = "garmin_connect";
  version = "3.0.20";

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "home-assistant-garmin_connect";
    tag = finalAttrs.version;
    hash = "sha256-x/JMmCKDqJabj3ZMKON4vz4MCGbmv+KLjHCHo31Otyo=";
  };

  dependencies = [
    ha-garmin
  ];

  # home-assistant-garmin_connect pins an exact version of ha-garmin, but we
  # want to allow newer, compatible versions to be used.
  ignoreVersionRequirement = [ "ha-garmin" ];

  meta = {
    changelog = "https://github.com/cyberjunky/home-assistant-garmin_connect/releases/tag/${finalAttrs.src.tag}";
    description = "Garmin Connect integration allows you to expose data from Garmin Connect to Home Assistant";
    homepage = "https://github.com/cyberjunky/home-assistant-garmin_connect";
    maintainers = with lib.maintainers; [
      matthiasbeyer
      dmadisetti
    ];
    license = lib.licenses.mit;
  };
})
