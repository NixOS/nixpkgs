{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  omnikinverter,
}:

buildHomeAssistantComponent rec {
  owner = "robbinjanssen";
  domain = "omnik_inverter";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "robbinjanssen";
    repo = "home-assistant-omnik-inverter";
    tag = version;
    hash = "sha256-L9us48J8fpIK3QHeEe3VhIAYBXbYegWYDi7OjeUollU=";
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
