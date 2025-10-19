{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  unstableGitUpdater,
  requests,
  pydantic,
}:

buildHomeAssistantComponent {
  owner = "NewsGuyTor";
  domain = "fellow";
  version = "0-unstable-2025-10-06";

  src = fetchFromGitHub {
    owner = "NewsGuyTor";
    repo = "FellowAiden-HomeAssistant";
    rev = "c0b724e2ac3174b99fcb7d05a9c63a3ac6ce03b4";
    hash = "sha256-gK9lVFehqRWq7HQd+VPJB/iaIvLdHu51XxyfM14aY0s=";
  };

  passthru.updateScript = unstableGitUpdater { };

  dependencies = [
    requests
    pydantic
  ];

  meta = {
    description = "Home Assistant integration for Fellow Aiden coffee brewer";
    homepage = "https://github.com/NewsGuyTor/FellowAiden-HomeAssistant";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
