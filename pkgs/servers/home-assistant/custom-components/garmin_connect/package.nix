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
  version = "0.2.29";

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "home-assistant-garmin_connect";
    tag = version;
    hash = "sha256-0zyOcuVgso086xME9H8L9OH2st7FqrPWOi6kksTM/f4=";
  };

  dependencies = [
    garminconnect
    tzlocal
  ];

  meta = with lib; {
    description = "The Garmin Connect integration allows you to expose data from Garmin Connect to Home Assistant";
    homepage = "https://github.com/cyberjunky/home-assistant-garmin_connect";
    maintainers = with maintainers; [
      matthiasbeyer
      dmadisetti
    ];
    license = licenses.mit;
  };
}
