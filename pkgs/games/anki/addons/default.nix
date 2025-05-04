{
  lib,
  anki-utils,
  fetchFromGitHub,
  nix-update-script,
}:
let
  inherit (anki-utils) buildAnkiAddon;
in
{
  adjust-sound-volume = buildAnkiAddon (finalAttrs: {
    pname = "adjust-sound-volume";
    version = "0.0.6";
    src = fetchFromGitHub {
      owner = "mnogu";
      repo = "adjust-sound-volume";
      rev = "v${finalAttrs.version}";
      hash = "sha256-6reIUz+tHKd4KQpuofLa/tIL5lCloj3yODZ8Cz29jFU=";
    };
    passthru.updateScript = nix-update-script { };
    meta = {
      description = "Adds a new menu item for adjusting the sound volume";
      homepage = "https://github.com/lambdadog/passfail2";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ junestepp ];
    };
  });
}
