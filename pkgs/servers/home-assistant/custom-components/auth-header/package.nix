{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "BeryJu";
  domain = "auth_header";
  version = "1.11";

  src = fetchFromGitHub {
    inherit owner;
    repo = "hass-auth-header";
    tag = "v${version}";
    hash = "sha256-N2jEFyb/OWsO48rAuQBDHtQ5yKfIrGTcwlEb2P3LyVc=";
  };

  meta = with lib; {
    changelog = "https://github.com/BeryJu/hass-auth-header/releases/tag/v${version}";
    description = "Home Assistant custom component which allows you to delegate authentication to a reverse proxy";
    homepage = "https://github.com/BeryJu/hass-auth-header";
    maintainers = with maintainers; [ mjm ];
    license = licenses.gpl3;
  };
}
