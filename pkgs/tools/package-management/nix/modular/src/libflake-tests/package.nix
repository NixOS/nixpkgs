{
  lib,
  buildPackages,
  stdenv,
  mkMesonExecutable,
  writableTmpDirAsHomeHook,

  nix-flake,
  nix-flake-c,
  nix-expr-test-support,

  rapidcheck,
  gtest,
  runCommand,

  # Configuration Options

  version,
  resolvePath,
}:

mkMesonExecutable (finalAttrs: {
  pname = "nix-flake-tests";
  inherit version;

  workDir = ./.;

  buildInputs = [
    nix-flake
    nix-flake-c
    nix-expr-test-support
    rapidcheck
    gtest
  ];

  mesonFlags = [
  ];

  passthru = {
    tests = {
      run =
        runCommand "${finalAttrs.pname}-run"
          {
            meta.broken = !stdenv.hostPlatform.emulatorAvailable buildPackages;
            buildInputs = [ writableTmpDirAsHomeHook ];
          }
          ''
            export _NIX_TEST_UNIT_DATA=${resolvePath ./data}
            export NIX_CONFIG="extra-experimental-features = flakes"
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
