{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  pyopensprinkler,
}:

buildHomeAssistantComponent rec {
  owner = "vinteo";
  domain = "opensprinkler";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "vinteo";
    repo = "hass-opensprinkler";
    tag = "v${version}";
    hash = "sha256-1wlknCsoLmin1b5uq0POjCZnzZB4styNPiaQWENZckc=";
  };

  dependencies = [
    pyopensprinkler
  ];

  meta = {
    changelog = "https://github.com/vinteo/hass-opensprinkler/releases/tag/${src.tag}";
    description = "OpenSprinkler Integration for Home Assistant";
    homepage = "https://github.com/vinteo/hass-opensprinkler";
    maintainers = with lib.maintainers; [ jfly ];
    license = lib.licenses.mit;
  };
}
