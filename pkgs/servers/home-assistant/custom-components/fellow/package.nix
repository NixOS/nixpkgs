{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  unstableGitUpdater,
  requests,
  pydantic,
}:

buildHomeAssistantComponent rec {
  owner = "kristofferR";
  domain = "fellow";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "kristofferR";
    repo = "FellowAiden-HomeAssistant";
    tag = "v${version}";
    hash = "sha256-n1D/kP1vxc+/kgZGwl+5nLD6IzERmMXeiQjSKZGiqvc=";
  };

  passthru.updateScript = unstableGitUpdater { };

  dependencies = [
    requests
    pydantic
  ];

  meta = {
    changelog = "https://github.com/kristofferR/FellowAiden-HomeAssistant/releases/tag/${src.tag}";
    description = "Home Assistant integration for Fellow Aiden coffee brewer";
    homepage = "https://github.com/kristofferR/FellowAiden-HomeAssistant";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
