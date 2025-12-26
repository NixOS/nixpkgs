{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  home-connect-async,
}:

buildHomeAssistantComponent rec {
  owner = "ekutner";
  domain = "home_connect_alt";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "ekutner";
    repo = "home-connect-hass";
    tag = version;
    hash = "sha256-X6yRoEJAmBDQzEo8WeEOMFZHJ6OOpw+XUKi+iHHOgOw=";
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
