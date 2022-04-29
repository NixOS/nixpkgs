{ stdenv, lib, fetchFromGitHub, rustPlatform, pkg-config, alsa-lib, openssl
, withTTS ? false, llvmPackages, speechd }:

rustPlatform.buildRustPackage rec {
  pname = "blightmud";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DaICzwBew90YstV42wiY0IbvR1W4Hm8dzo3xY2qlMGQ=";
  };

  cargoSha256 = "sha256-BamMTPh+GN9GG4puxyTauPhjCC8heCu1wsgFaw98s9U=";

  buildFeatures = lib.optional withTTS "tts";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ alsa-lib openssl ] ++ lib.optional withTTS [ speechd ];

  # Building the speech-dispatcher-sys crate for TTS support requires setting
  # LIBCLANG_PATH.
  LIBCLANG_PATH = lib.optionalString withTTS "${llvmPackages.libclang.lib}/lib";

  preBuild = lib.optionalString withTTS ''
    # When building w/ TTS the speech-dispatcher-sys crate's build.rs uses
    # rust-bindgen with libspeechd. This bypasses the normal nixpkgs CC wrapper
    # so we have to adapt the BINDGEN_EXTRA_CLANG_ARGS env var to compensate. See
    # this blog post[0] for more information.
    #
    # [0]: https://hoverbear.org/blog/rust-bindgen-in-nix/

    export BINDGEN_EXTRA_CLANG_ARGS="$(< ${stdenv.cc}/nix-support/libc-cflags) \
      $(< ${stdenv.cc}/nix-support/cc-cflags) \
      -isystem ${llvmPackages.libclang.lib}/lib/clang/${
        lib.getVersion llvmPackages.clang
      }/include \
      -idirafter ${stdenv.cc.cc}/lib/gcc/${stdenv.hostPlatform.config}/${
        lib.getVersion stdenv.cc.cc
      }/include \
      -idirafter ${speechd}/include"
  '';

  checkFlags = let
    # Most of Blightmud's unit tests pass without trouble in the isolated
    # Nixpkgs build env. The following tests need to be skipped.
    skipList = [
      "test_connect"
      "test_gmcp_negotiation"
      "test_ttype_negotiation"
      "test_reconnect"
      "test_mud"
      "test_server"
      "test_lua_script"
      "timer_test"
      "validate_assertion_fail"
    ];
    skipFlag = test: "--skip " + test;
  in builtins.concatStringsSep " " (builtins.map skipFlag skipList);

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
