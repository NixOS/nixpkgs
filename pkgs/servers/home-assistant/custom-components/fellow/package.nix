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
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "NewsGuyTor";
    repo = "FellowAiden-HomeAssistant";
    tag = "v${version}";
    hash = "sha256-qJizRqHcYQxcONke/++Hjh6yzHNCxfytvAJYXJWoHu8=";
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
