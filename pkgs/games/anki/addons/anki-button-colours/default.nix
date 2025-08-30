{
  lib,
  anki-utils,
  fetchFromGitHub,
  nix-update-script,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "anki-button-colours";
  version = "2.1.1";
  src = fetchFromGitHub {
    owner = "teaqu";
    repo = "anki-button-colours";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PI2Whtm5/q/X4cnFyANjFQtErOXqdDTSBWPXJjlyTj8=";
  };
  passthru.updateScript = nix-update-script { };
  meta = {
    description = "Button colours for Anki";
    homepage = "https://ankiweb.net/shared/info/2494384865";
    downloadPage = "https://github.com/teaqu/anki-button-colours";
    changelog = "https://github.com/teaqu/anki-button-colours/tree/v${finalAttrs.version}";
    # No license file, but it can be assumed to be AGPL3 based on
    # https://ankiweb.net/account/terms.
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
})
