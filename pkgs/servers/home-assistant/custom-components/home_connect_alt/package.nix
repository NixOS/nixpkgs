{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  home-connect-async,
}:

buildHomeAssistantComponent rec {
  owner = "ekutner";
  domain = "home_connect_alt";
  version = "1.3.0-b1";

  src = fetchFromGitHub {
    owner = "ekutner";
    repo = "home-connect-hass";
    tag = version;
    hash = "sha256-jWrVHwMdzjG0gHWl1NS6WAzdmlmS20BUmh6HzplsGgw=";
  };

  dependencies = [ home-connect-async ];

  meta = with lib; {
    description = "Alternative (and improved) Home Connect integration for Home Assistant";
    homepage = "https://github.com/ekutner/home-connect-hass";
    maintainers = with maintainers; [ kranzes ];
    license = licenses.mit;
  };
}
