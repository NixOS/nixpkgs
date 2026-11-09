{
  lib,
  mkMesonLibrary,

  nix-util-test-support,
  nix-store,
  nix-store-c,

  rapidcheck,

  gtest,

  # Configuration Options

  version,
}:

mkMesonLibrary (finalAttrs: {
  pname = "nix-store-test-support";
  inherit version;

  workDir = ./.;

  propagatedBuildInputs = [
    nix-util-test-support
    nix-store
    nix-store-c
    rapidcheck
    gtest
  ];

  mesonFlags = [
  ];

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
