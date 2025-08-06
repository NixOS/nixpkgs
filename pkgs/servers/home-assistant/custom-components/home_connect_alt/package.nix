{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  home-connect-async,
}:

buildHomeAssistantComponent rec {
  owner = "ekutner";
  domain = "home_connect_alt";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "ekutner";
    repo = "home-connect-hass";
    tag = version;
    hash = "sha256-v/C4KV/WddaXQIO709nHP4DJM/K3J3WQSrJnVaXQDSY=";
  };

  dependencies = [ home-connect-async ];

  meta = with lib; {
    description = "Alternative (and improved) Home Connect integration for Home Assistant";
    homepage = "https://github.com/ekutner/home-connect-hass";
    maintainers = with maintainers; [ kranzes ];
    license = licenses.mit;
  };
}
