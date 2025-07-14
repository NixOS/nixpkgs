{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "BeryJu";
  domain = "auth_header";
  version = "1.12";

  src = fetchFromGitHub {
    inherit owner;
    repo = "hass-auth-header";
    tag = "v${version}";
    hash = "sha256-BPG/G6IM95g9ip2OsPmcAebi2ZvKHUpFzV4oquOFLPM=";
  };

  meta = with lib; {
    changelog = "https://github.com/BeryJu/hass-auth-header/releases/tag/v${version}";
    description = "Home Assistant custom component which allows you to delegate authentication to a reverse proxy";
    homepage = "https://github.com/BeryJu/hass-auth-header";
    maintainers = with maintainers; [ mjm ];
    license = licenses.gpl3;
  };
}
