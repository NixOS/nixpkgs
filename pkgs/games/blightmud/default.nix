{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, alsa-lib
, openssl
, withTTS ? false
, speechd
}:

rustPlatform.buildRustPackage rec {
  pname = "blightmud";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-80uTwbZjXoQnfP0VWM/CnvaHyRsPA1puASJwBm3GqJk=";
  };

  cargoSha256 = "sha256-uXr/5G0TH3EKqPwUKTwOguBExBEYB1D3/hr8nzOwCcM=";

  buildFeatures = lib.optional withTTS "tts";

  nativeBuildInputs = [ pkg-config rustPlatform.bindgenHook ];

  buildInputs = [ alsa-lib openssl ] ++ lib.optional withTTS [ speechd ];

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
      ];
      skipFlag = test: "--skip " + test;
    in
    builtins.concatStringsSep " " (builtins.map skipFlag skipList);

  meta = with lib; {
    description = "A terminal MUD client written in Rust";
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
    platforms = platforms.linux;
  };
}
