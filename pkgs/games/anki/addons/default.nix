{
  lib,
  anki-utils,
  fetchFromGitHub,
  fetchFromSourcehut,
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

  anki-connect = buildAnkiAddon (finalAttrs: {
    pname = "anki-connect";
    version = "24.7.25.0";
    src = fetchFromSourcehut {
      owner = "~foosoft";
      repo = "anki-connect";
      rev = finalAttrs.version;
      hash = "sha256-N98EoCE/Bx+9QUQVeU64FXHXSek7ASBVv1b9ltJ4G1U=";
    };
    sourceRoot = "source/plugin";
    passthru.updateScript = nix-update-script { };
    meta = {
      description = ''
        Enables external applications such as Yomichan to communicate
        with Anki over a simple HTTP API
      '';
      homepage = "https://foosoft.net/projects/anki-connect/";
      license = lib.licenses.gpl3Plus;
      maintainers = with lib.maintainers; [ junestepp ];
    };
  });

  passfail2 = buildAnkiAddon (finalAttrs: {
    pname = "passfail2";
    version = "0.3.0-unstable-2024-10-17";
    src = fetchFromGitHub {
      owner = "lambdadog";
      repo = "passfail2";
      rev = "d5313e4f1217e968b36edbc0a4fe92386209ffe6";
      hash = "sha256-HMe6/fHpYj/MN0dUFj3W71vK7qqcp9l1xm8SAiKkJLs=";
    };
    buildPhase = ''
      runHook preBuild

      substitute build_info.py.in build_info.py \
        --replace-fail '$version' '"${finalAttrs.version}"'

      runHook postBuild
    '';
    passthru.updateScript = nix-update-script { };
    meta = {
      description = ''
        Replaces the default Anki review buttons with only two options:
        “Fail” and “Pass”
      '';
      homepage = "https://github.com/lambdadog/passfail2";
      license = lib.licenses.gpl3;
      maintainers = with lib.maintainers; [ junestepp ];
    };
  });
}
