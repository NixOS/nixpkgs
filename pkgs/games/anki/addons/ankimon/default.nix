{
  lib,
  anki-utils,
  fetchFromGitHub,
  nix-update-script,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "ankimon";
  version = "1.288";
  src = fetchFromGitHub {
    owner = "Unlucky-Life";
    repo = "ankimon";
    tag = finalAttrs.version;
    hash = "sha256-PPTmZpxeBv0zb8wbxLEozDdRJG+eYjMqGyx8y5na1MQ=";
  };
  passthru.updateScript = nix-update-script { };
  meta = {
    description = "Anki plugin to gamify your learning experience with Pokemon";
    homepage = "https://ankiweb.net/shared/info/1908235722";
    downloadPage = "https://github.com/Unlucky-Life/ankimon";
    changelog = "https://github.com/Unlucky-Life/ankimon/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    # no use in having hydra deal with a ~500MB file
    # when it essentially is just downloading and copying
    # files
    hydraPlatforms = [ ];
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
})
