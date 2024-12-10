{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  garminconnect,
  tzlocal,
}:

buildHomeAssistantComponent {
  owner = "cyberjunky";
  domain = "garmin_connect";
  version = "unstable-2024-08-31";

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "home-assistant-garmin_connect";
    rev = "d42edcabc67ba6a7f960e849c8aaec1aabef87c0";
    hash = "sha256-KqbP6TpH9B0/AjtsW5TcWSNgUhND+w8rO6X8fHqtsDI=";
  };

  propagatedBuildInputs = [
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
