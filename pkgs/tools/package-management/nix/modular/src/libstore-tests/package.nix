{
  lib,
  buildPackages,
  stdenv,
  mkMesonExecutable,
  writableTmpDirAsHomeHook,

  nix-store,
  nix-store-c,
  nix-store-test-support,
  sqlite,

  openssl,

  rapidcheck,
  gtest,
  runCommand,

  # Configuration Options

  version,
  filesetToSource,
}:

mkMesonExecutable (finalAttrs: {
  pname = "nix-store-tests";
  inherit version;

  workDir = ./.;

  buildInputs = [
    sqlite
    rapidcheck
    gtest

    nix-store
    nix-store-c
    nix-store-test-support
  ];

  mesonFlags = [
  ];

  passthru = {
    tests = {
      run =
        let
          # Some data is shared with the functional tests: they create it,
          # we consume it.
          data = filesetToSource {
            root = ../..;
            fileset = lib.fileset.unions [
              ./data
              ../../tests/functional/derivation
            ];
          };
        in
        runCommand "${finalAttrs.pname}-run"
          {
            meta.broken = !stdenv.hostPlatform.emulatorAvailable buildPackages;
            nativeBuildInputs = [
              writableTmpDirAsHomeHook
              (lib.getBin openssl)
            ];
          }
          ''
            export _NIX_TEST_UNIT_DATA=${data + "/src/libstore-tests/data"}
            export NIX_REMOTE=$HOME/store
            ${stdenv.hostPlatform.emulator buildPackages} ${lib.getExe finalAttrs.finalPackage}
            touch $out
          '';
    };
  };

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    mainProgram = finalAttrs.pname + stdenv.hostPlatform.extensions.executable;
  };

})
