{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  omnikinverter,
}:

buildHomeAssistantComponent rec {
  owner = "robbinjanssen";
  domain = "omnik_inverter";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "robbinjanssen";
    repo = "home-assistant-omnik-inverter";
    tag = version;
    hash = "sha256-jbUEkWgnq+GODPgzK1y1bXLDuRrfEg6wZn6WpDH2SZ0=";
  };

  dependencies = [
    omnikinverter
  ];

  doCheck = false; # no tests

  meta = {
    changelog = "https://github.com/robbinjanssen/home-assistant-omnik-inverter/releases/tag/${src.tag}";
    description = "Omnik Inverter integration will scrape data from an Omnik inverter connected to your local network";
    homepage = "https://github.com/robbinjanssen/home-assistant-omnik-inverter";
    maintainers = with lib.maintainers; [ _9R ];
    license = lib.licenses.mit;
  };
}
