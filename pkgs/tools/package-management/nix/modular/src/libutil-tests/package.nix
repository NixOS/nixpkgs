{
  lib,
  buildPackages,
  stdenv,
  mkMesonExecutable,

  nix-util,
  nix-util-c,
  nix-util-test-support,

  rapidcheck,
  gtest,
  runCommand,

  # Configuration Options

  version,
  resolvePath,
}:

mkMesonExecutable (finalAttrs: {
  pname = "nix-util-tests";
  inherit version;

  workDir = ./.;

  buildInputs = [
    nix-util
    nix-util-c
    nix-util-test-support
    rapidcheck
    gtest
  ];

  mesonFlags = [
  ];

  excludedTestPatterns = lib.optionals (lib.versions.majorMinor version == "2.34") [
    "fchmodatTryNoFollow.fallbackWithoutProc"
  ];

  passthru = {
    tests = {
      run =
        runCommand "${finalAttrs.pname}-run"
          {
            meta.broken = !stdenv.hostPlatform.emulatorAvailable buildPackages;
          }
          (
            lib.optionalString stdenv.hostPlatform.isWindows ''
              export HOME="$PWD/home-dir"
              mkdir -p "$HOME"
            ''
            + ''
              export _NIX_TEST_UNIT_DATA=${resolvePath ./data}
              ${stdenv.hostPlatform.emulator buildPackages} ${lib.getExe finalAttrs.finalPackage} \
                --gtest_filter=-${lib.concatStringsSep ":" finalAttrs.excludedTestPatterns}
              touch $out
            ''
          );
    };
  };

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    mainProgram = finalAttrs.pname + stdenv.hostPlatform.extensions.executable;
  };

})
