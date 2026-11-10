{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  pyopensprinkler,
  suntime,
}:

buildHomeAssistantComponent rec {
  owner = "vinteo";
  domain = "opensprinkler";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "vinteo";
    repo = "hass-opensprinkler";
    tag = "v${version}";
    hash = "sha256-r7VtlV1Yo3wn6x8BuYrrr6OlIBKZA3hmfVrBCYLXArM=";
  };

  dependencies = [
    pyopensprinkler
    suntime
  ];

  ignoreVersionRequirement = [
    "suntime" # https://github.com/vinteo/hass-opensprinkler/issues/393
  ];

  meta = {
    changelog = "https://github.com/vinteo/hass-opensprinkler/releases/tag/${src.tag}";
    description = "OpenSprinkler Integration for Home Assistant";
    homepage = "https://github.com/vinteo/hass-opensprinkler";
    maintainers = with lib.maintainers; [ jfly ];
    license = lib.licenses.mit;
  };
}
