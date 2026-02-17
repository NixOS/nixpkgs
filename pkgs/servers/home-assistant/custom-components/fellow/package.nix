{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  unstableGitUpdater,
  requests,
  pydantic,
}:

buildHomeAssistantComponent rec {
  owner = "NewsGuyTor";
  domain = "fellow";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "NewsGuyTor";
    repo = "FellowAiden-HomeAssistant";
    tag = "v${version}";
    hash = "sha256-cGyGobR0lMNReWCxK7RzeqsnYJZQNRPjYqirLHjeCFI=";
  };

  passthru.updateScript = unstableGitUpdater { };

  dependencies = [
    requests
    pydantic
  ];

  meta = {
    changelog = "https://github.com/NewsGuyTor/FellowAiden-HomeAssistant/releases/tag/${src.tag}";
    description = "Home Assistant integration for Fellow Aiden coffee brewer";
    homepage = "https://github.com/NewsGuyTor/FellowAiden-HomeAssistant";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
