{ lib
, buildPackages
, stdenv
, mkMesonExecutable

, nix-util
, nix-util-c
, nix-util-test-support

, rapidcheck
, gtest
, runCommand

# Configuration Options

, version
}:

let
  inherit (lib) fileset;
in

mkMesonExecutable (finalAttrs: {
  pname = "nix-util-tests";
  inherit version;

  workDir = ./.;
  fileset = fileset.unions [
    ../../build-utils-meson
    ./build-utils-meson
    ../../.version
    ./.version
    ./meson.build
    # ./meson.options
    (fileset.fileFilter (file: file.hasExt "cc") ./.)
    (fileset.fileFilter (file: file.hasExt "hh") ./.)
  ];

  buildInputs = [
    nix-util
    nix-util-c
    nix-util-test-support
    rapidcheck
    gtest
  ];

  preConfigure =
    # "Inline" .version so it's not a symlink, and includes the suffix.
    # Do the meson utils, without modification.
    ''
      chmod u+w ./.version
      echo ${version} > ../../.version
    '';

  mesonFlags = [
  ];

  env = lib.optionalAttrs (stdenv.isLinux && !(stdenv.hostPlatform.isStatic && stdenv.system == "aarch64-linux")) {
    LDFLAGS = "-fuse-ld=gold";
  };

  passthru = {
    tests = {
      run = runCommand "${finalAttrs.pname}-run" {
        meta.broken = !stdenv.hostPlatform.emulatorAvailable buildPackages;
      } (lib.optionalString stdenv.hostPlatform.isWindows ''
        export HOME="$PWD/home-dir"
        mkdir -p "$HOME"
      '' + ''
        export _NIX_TEST_UNIT_DATA=${./data}
        ${stdenv.hostPlatform.emulator buildPackages} ${lib.getExe finalAttrs.finalPackage}
        touch $out
      '');
    };
  };

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    mainProgram = finalAttrs.pname + stdenv.hostPlatform.extensions.executable;
  };

})
