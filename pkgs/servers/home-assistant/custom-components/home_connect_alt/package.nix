{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  home-connect-async,
}:

buildHomeAssistantComponent rec {
  owner = "ekutner";
  domain = "home_connect_alt";
  version = "1.5.0-b1";

  src = fetchFromGitHub {
    owner = "ekutner";
    repo = "home-connect-hass";
    tag = version;
    hash = "sha256-i4yg+f9dCIshw1xsSZuVOE5uHcTJ5etQpct6vfPmK3M=";
  };

  dependencies = [ home-connect-async ];

  meta = {
    changelog = "https://github.com/ekutner/home-connect-hass/releases/tag/${src.tag}";
    description = "Alternative (and improved) Home Connect integration for Home Assistant";
    homepage = "https://github.com/ekutner/home-connect-hass";
    maintainers = with lib.maintainers; [ kranzes ];
    license = lib.licenses.mit;
  };
}
