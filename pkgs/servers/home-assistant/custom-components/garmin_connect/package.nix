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
  version = "0.2.30";

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "home-assistant-garmin_connect";
    tag = version;
    hash = "sha256-Gxz0mKVgs2o7IlhGJkz4JlKRb448IRFqK87Kn+Gebkk=";
  };

  dependencies = [
    garminconnect
    tzlocal
  ];

  meta = {
    description = "Garmin Connect integration allows you to expose data from Garmin Connect to Home Assistant";
    homepage = "https://github.com/cyberjunky/home-assistant-garmin_connect";
    maintainers = with lib.maintainers; [
      matthiasbeyer
      dmadisetti
    ];
    license = lib.licenses.mit;
  };
}
