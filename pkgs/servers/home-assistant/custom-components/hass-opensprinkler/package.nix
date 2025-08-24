{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  pyopensprinkler,
}:

buildHomeAssistantComponent rec {
  owner = "vinteo";
  domain = "opensprinkler";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "vinteo";
    repo = "hass-opensprinkler";
    tag = "v${version}";
    hash = "sha256-cq9BCN/lvEZ5xPt4cLOFwNP36S+u0hQr4o2gGFz0IGo=";
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
