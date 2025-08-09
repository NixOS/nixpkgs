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
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "NewsGuyTor";
    repo = "FellowAiden-HomeAssistant";
    rev = "2268880c7727b1d2e488dcebbdc5b2675d664ddf";
    hash = "sha256-Wg6EFUQNhlK2GQjC90c5lA3b/y40LhXdInba/iTtUWc=";
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
