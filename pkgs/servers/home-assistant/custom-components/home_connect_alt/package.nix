{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  home-connect-async,
}:

buildHomeAssistantComponent rec {
  owner = "ekutner";
  domain = "home_connect_alt";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "ekutner";
    repo = "home-connect-hass";
    tag = version;
    hash = "sha256-t5Af58HgYVMZki/93t63X2JPXDJm7PPt84yGj7MJKkE=";
  };

  dependencies = [ home-connect-async ];

  meta = with lib; {
    changelog = "https://github.com/ekutner/home-connect-hass/releases/tag/${src.tag}";
    description = "Alternative (and improved) Home Connect integration for Home Assistant";
    homepage = "https://github.com/ekutner/home-connect-hass";
    maintainers = with maintainers; [ kranzes ];
    license = licenses.mit;
  };
}
