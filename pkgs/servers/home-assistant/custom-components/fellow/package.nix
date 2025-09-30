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
  version = "0-unstable-2025-08-06";

  src = fetchFromGitHub {
    owner = "NewsGuyTor";
    repo = "FellowAiden-HomeAssistant";
    rev = "bb0f3042e974a149a3597d06312e6be9b8d265ff";
    hash = "sha256-cplIiFt0CkeOXjypvG0MR/t7PWzeaa2G6uScWSLbEpo=";
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
