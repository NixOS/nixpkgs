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
  toml11,

  busybox-sandbox-shell ? null,

  # Configuration Options

  pname ? "nix-functional-tests",
  version,

  # For running the functional tests against a different pre-built Nix.
  test-daemon ? null,
}:

mkMesonDerivation (
  finalAttrs:
  {
    inherit pname version;

    workDir = ./.;

    # Hack for sake of the dev shell
    passthru.externalNativeBuildInputs = [
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
    ];

    nativeBuildInputs = finalAttrs.passthru.externalNativeBuildInputs ++ [
      nix-cli
    ];

    buildInputs = [
      nix-store
      nix-expr
    ];

    preConfigure =
      # TEMP hack for Meson before make is gone, where
      # `src/nix-functional-tests` is during the transition a symlink and
      # not the actual directory directory.
      ''
        cd $(readlink -e $PWD)
        echo $PWD | grep tests/functional
      '';

    # `toml11` upgrade causes these to fail in 2.32+: https://github.com/NixOS/nixpkgs/pull/442682
    # Remove when that PR lands in master.
    ${if lib.versionAtLeast (lib.versions.majorMinor version) "2.32" then "preCheck" else null} =
      lib.optionalString (lib.versionOlder toml11.version "4.0") ''
        rm -f ../lang/eval-fail-fromTOML-{over,under}flow*
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

  }
  // lib.optionalAttrs (test-daemon != null) {
    NIX_DAEMON_PACKAGE = test-daemon;
    _NIX_TEST_CLIENT_VERSION = nix-cli.version;
  }
)
