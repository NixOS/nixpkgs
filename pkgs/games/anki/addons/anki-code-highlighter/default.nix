{
  lib,
  anki-utils,
  fetchFromGitHub,
  nix-update-script,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "anki-code-highlighter";
  version = "25.07.0";
  src = fetchFromGitHub {
    owner = "gregorias";
    repo = "anki-code-highlighter";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-mGRW4pDCxXgeSZQAyGNr6Ghp+jUIzro07Qowve57VqA=";
  };
  passthru.updateScript = nix-update-script { };
  meta = {
    description = "Anki plugin for code syntax highlighting";
    homepage = "https://ankiweb.net/shared/info/112228974";
    downloadPage = "https://github.com/gregorias/anki-code-highlighter";
    changelog = "https://github.com/gregorias/anki-code-highlighter/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
})
