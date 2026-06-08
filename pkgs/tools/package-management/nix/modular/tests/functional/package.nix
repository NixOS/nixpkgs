{
  lib,
  stdenv,
  mkMesonDerivation,

  meson,
  ninja,
  pkg-config,

  jq,
  git,
  mercurial,
  util-linux,

  nix-store,
  nix-expr,
  nix-cli,

  busybox-sandbox-shell ? null,

  # Configuration Options

  pname ? "nix-functional-tests",
  version,

  # For running the functional tests against a different pre-built Nix.
  test-daemon ? null,
}:

mkMesonDerivation (finalAttrs: {
  inherit pname version;

  workDir = ./.;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config

    jq
    git
    mercurial
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # For various sandboxing tests that needs a statically-linked shell,
    # etc.
    busybox-sandbox-shell
    # For Overlay FS tests need `mount`, `umount`, and `unshare`.
    # For `script` command (ensuring a TTY)
    # TODO use `unixtools` to be precise over which executables instead?
    util-linux
  ]
  ++ [
    nix-cli
  ];

  buildInputs = [
    nix-store
    nix-expr
  ];

  env = lib.optionalAttrs (test-daemon != null) {
    NIX_DAEMON_PACKAGE = test-daemon;
    _NIX_TEST_CLIENT_VERSION = nix-cli.version;
  };

  preConfigure =
    # TEMP hack for Meson before make is gone, where
    # `src/nix-functional-tests` is during the transition a symlink and
    # not the actual directory directory.
    ''
      cd $(readlink -e $PWD)
      echo $PWD | grep tests/functional
    '';

  # Test contains invocation of `script` broken by util-linux regression:
  # https://github.com/util-linux/util-linux/commit/70507ab9eaed10b8dd77b77d4ea25c11ee726bed
  preCheck =
    assert util-linux.version == "2.42";
    ''
      echo "exit 77" > ../json.sh
    '';

  mesonCheckFlags = [
    "--print-errorlogs"
  ];

  doCheck = true;

  installPhase = ''
    mkdir $out
  '';

  meta = {
    platforms = lib.platforms.unix;
  };

})
