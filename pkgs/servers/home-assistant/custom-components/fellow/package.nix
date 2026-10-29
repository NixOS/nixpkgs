{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  unstableGitUpdater,
  requests,
  pydantic,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "kristofferR";
  domain = "fellow";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "kristofferR";
    repo = "FellowAiden-HomeAssistant";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DiVEHIPyMzbifydNarOAo4aMoMxoOW5AWRx7tvviPQA=";
  };

  passthru.updateScript = unstableGitUpdater { };

  dependencies = [
    requests
    pydantic
  ];

  meta = {
    changelog = "https://github.com/kristofferR/FellowAiden-HomeAssistant/releases/tag/${finalAttrs.src.tag}";
    description = "Home Assistant integration for Fellow Aiden coffee brewer";
    homepage = "https://github.com/kristofferR/FellowAiden-HomeAssistant";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
