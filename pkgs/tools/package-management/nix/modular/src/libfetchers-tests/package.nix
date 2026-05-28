{
  lib,
  buildPackages,
  stdenv,
  mkMesonExecutable,
  writableTmpDirAsHomeHook,

  nix-fetchers,
  nix-fetchers-c,
  nix-store-test-support,

  libgit2,
  rapidcheck,
  gtest,
  runCommand,

  # Configuration Options

  version,
  resolvePath,
}:

mkMesonExecutable (finalAttrs: {
  pname = "nix-fetchers-tests";
  inherit version;

  workDir = ./.;

  buildInputs = [
    nix-fetchers
    nix-store-test-support
    rapidcheck
    gtest
  ]
  ++ lib.optionals (lib.versionAtLeast version "2.29pre") [
    nix-fetchers-c
  ]
  ++ lib.optionals (lib.versionAtLeast version "2.27") [
    libgit2
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
