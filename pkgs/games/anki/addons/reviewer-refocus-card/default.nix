{
  lib,
  anki-utils,
  fetchFromGitHub,
  nix-update-script,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "reviewer-refocus-card";
  version = "0-unstable-2022-12-24";
  src = fetchFromGitHub {
    owner = "glutanimate";
    repo = "anki-addons-misc";
    rev = "7b981836e0a6637a1853f3e8d73d022ab95fed31";
    sparseCheckout = [ "src/reviewer_refocus_card" ];
    hash = "sha256-181hyc4ED+0lBzn1FnrBvNIYIUQF8xEDB3uHK6SkpHw=";
  };
  sourceRoot = "${finalAttrs.src.name}/src/reviewer_refocus_card";
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };
  meta = {
    description = ''
      Set focus to the card area, allowing you to scroll through your cards using
      Page Up / Page Down, etc
    '';
    homepage = "https://github.com/glutanimate/anki-addons-misc";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ junestepp ];
  };
})
