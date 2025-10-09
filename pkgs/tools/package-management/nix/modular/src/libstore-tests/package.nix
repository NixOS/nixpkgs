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

  # Hack for sake of the dev shell
  passthru.externalBuildInputs = [
    sqlite
    rapidcheck
    gtest
  ];

  buildInputs = finalAttrs.passthru.externalBuildInputs ++ [
    nix-store
    nix-store-c
    nix-store-test-support
  ];

  mesonFlags = [
  ];

  excludedTestPatterns = lib.optionals (lib.versionOlder finalAttrs.version "2.31") [
    "nix_api_util_context.nix_store_real_path_binary_cache"
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
            buildInputs = [ writableTmpDirAsHomeHook ];
          }
          ''
            export _NIX_TEST_UNIT_DATA=${data + "/src/libstore-tests/data"}
            export NIX_REMOTE=$HOME/store
            ${stdenv.hostPlatform.emulator buildPackages} ${lib.getExe finalAttrs.finalPackage} \
              --gtest_filter=-${lib.concatStringsSep ":" finalAttrs.excludedTestPatterns}
            touch $out
          '';
    };
  };

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    mainProgram = finalAttrs.pname + stdenv.hostPlatform.extensions.executable;
  };

})
