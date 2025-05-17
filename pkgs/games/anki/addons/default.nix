{
  lib,
  anki-utils,
  fetchFromGitHub,
  fetchFromSourcehut,
  nix-update-script,
  python3,
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

  recolor = anki-utils.buildAnkiAddon (finalAttrs: {
    pname = "recolor";
    version = "3.1";
    src = fetchFromGitHub {
      owner = "AnKing-VIP";
      repo = "AnkiRecolor";
      rev = finalAttrs.version;
      sparseCheckout = [ "src/addon" ];
      hash = "sha256-28DJq2l9DP8O6OsbNQCZ0pm4S6CQ3Yz0Vfvlj+iQw8Y=";
    };
    sourceRoot = "source/src/addon";
    passthru.updateScript = nix-update-script { };
    meta = {
      description = ''
        ReColor your Anki desktop to whatever aesthetic you like
      '';
      homepage = "https://github.com/AnKing-VIP/AnkiRecolor";
      # No license file, but it can be assumed to be AGPL3 based on
      # https://ankiweb.net/account/terms.
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ junestepp ];
    };
  });

  reviewer-refocus-card = buildAnkiAddon {
    pname = "reviewer-refocus-card";
    version = "0-unstable-2022-12-24";
    src = fetchFromGitHub {
      owner = "glutanimate";
      repo = "anki-addons-misc";
      rev = "7b981836e0a6637a1853f3e8d73d022ab95fed31";
      sparseCheckout = [ "src/reviewer_refocus_card" ];
      hash = "sha256-181hyc4ED+0lBzn1FnrBvNIYIUQF8xEDB3uHK6SkpHw=";
    };
    sourceRoot = "source/src/reviewer_refocus_card";
    passthru.updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };
    meta = {
      description = ''
        Sets focus to the card area, allowing you to scroll through your cards using
        Page Up / Page Down, etc
      '';
      homepage = "https://github.com/glutanimate/anki-addons-misc";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ junestepp ];
    };
  };

  yomichan-forvo-server = buildAnkiAddon {
    pname = "yomichan-forvo-server";
    version = "0-unstable-2024-10-21";
    src = fetchFromGitHub {
      owner = "jamesnicolas";
      repo = "yomichan-forvo-server";
      rev = "364fc6d5d10969f516e0fa283460dfaf08c98e15";
      hash = "sha256-Jpee9hkXCiBmSW7hzJ1rAg45XVIiLC8WENc09+ySFVI=";
    };
    passthru.updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };
    meta = {
      description = "An audio server for yomichan that scrapes forvo for audio files";
      homepage = "https://github.com/jamesnicolas/yomichan-forvo-server";
      license = lib.licenses.unlicense;
      maintainers = with lib.maintainers; [ junestepp ];
    };
  };

  local-audio-yomichan = buildAnkiAddon {
    pname = "local-audio-yomichan";
    version = "0-unstable-2025-04-26";
    src = fetchFromGitHub {
      owner = "yomidevs";
      repo = "local-audio-yomichan";
      rev = "34750f1d8ca1cb473128fea7976a4d981e5e78a4";
      sparseCheckout = [ "plugin" ];
      hash = "sha256-2gyggcvxParay+1B7Sg2COKyocoxaRO1WTz+ymdRp4w=";
    };
    sourceRoot = "source/plugin";
    processUserFiles = ''
      # Addon will try to load extra stuff unless Python package name is "plugin".
      temp=$(mktemp -d)
      ln -s $PWD $temp/plugin
      # Addoon expects `user_files` dir at `$XDG_DATA_HOME/local-audio-yomichan`
      ln -s $PWD/user_files $temp/local-audio-yomichan

      PYTHONPATH=$temp \
      WO_ANKI=1 \
      XDG_DATA_HOME=$temp \
      ${lib.getExe python3} -c \
        "from plugin import db_utils; \
         db_utils.init_db()"
    '';
    passthru.updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };
    meta = {
      description = "Anki add-on to run a local audio server for Yomitan";
      homepage = "https://github.com/yomidevs/local-audio-yomichan";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ junestepp ];
    };
  };
}
