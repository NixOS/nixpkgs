{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, alsa-lib
, openssl
, withTTS ? false
, speechd-minimal
, darwin
}:
let
  inherit (darwin.apple_sdk.frameworks)
    CoreAudio AudioUnit AVFoundation AppKit;
in
rustPlatform.buildRustPackage rec {
  pname = "blightmud";
  version = "5.3.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9GUul5EoejcnCQqq1oX+seBtxttYIUhgcexaZk+7chk=";
  };

  cargoHash = "sha256-84m5dihmiEGrFCajqaMW05MQtBceLodBzqtjW+zh6kg=";

  buildFeatures = lib.optional withTTS "tts";

  nativeBuildInputs = [ pkg-config rustPlatform.bindgenHook ];

  buildInputs = [ openssl ]
    ++ lib.optionals (withTTS && stdenv.hostPlatform.isLinux) [ speechd-minimal ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ]
    ++ lib.optionals (withTTS && stdenv.hostPlatform.isDarwin) [ AVFoundation AppKit ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ CoreAudio AudioUnit ];

  checkFlags =
    let
      # Most of Blightmud's unit tests pass without trouble in the isolated
      # Nixpkgs build env. The following tests need to be skipped.
      skipList = [
        "test_connect"
        "test_gmcp_negotiation"
        "test_ttype_negotiation"
        "test_reconnect"
        "test_is_connected"
        "test_mud"
        "test_server"
        "test_lua_script"
        "timer_test"
        "validate_assertion_fail"
        "regex_smoke_test"
        "test_tls_init_verify_err"
        "test_tls_init_no_verify"
        "test_tls_init_verify"
      ];
      skipFlag = test: "--skip " + test;
    in
    builtins.concatStringsSep " " (builtins.map skipFlag skipList);

  meta = with lib; {
    description = "Terminal MUD client written in Rust";
    mainProgram = "blightmud";
    longDescription = ''
      Blightmud is a terminal client for connecting to Multi User Dungeon (MUD)
      games. It is written in Rust and supports TLS, GMCP, MSDP, MCCP2, tab
      completion, text searching and a split view for scrolling. Blightmud can
      be customized with Lua scripting for aliases, triggers, timers, customized
      status bars, and more. Blightmud supports several accessibility features
      including an optional built-in text-to-speech engine and a screen reader
      friendly mode.
    '';
    homepage = "https://github.com/Blightmud/Blightmud";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ cpu ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
