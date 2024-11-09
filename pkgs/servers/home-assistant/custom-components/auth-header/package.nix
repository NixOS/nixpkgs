{ lib
, buildHomeAssistantComponent
, fetchFromGitHub
}:

buildHomeAssistantComponent rec {
  owner = "BeryJu";
  domain = "auth_header";
  version = "1.10-unstable-2024-02-26";

  src = fetchFromGitHub {
    inherit owner;
    repo = "hass-auth-header";
    rev = "5923cb33b57a9d3c23513d54cc74b02ebd243409";
    hash = "sha256-ZYd1EduzoljaY3OnpjsKEAwtf03435zJmZtgqzbdjjA=";
  };

  # build step just runs linter
  dontBuild = true;

  meta = with lib; {
    description = "Home Assistant custom component which allows you to delegate authentication to a reverse proxy";
    homepage = "https://github.com/BeryJu/hass-auth-header";
    maintainers = with maintainers; [ mjm ];
    license = licenses.gpl3;
  };
}
