{
  lib,
  mkMesonLibrary,

  nix-util,
  nix-util-c,

  rapidcheck,

  # Configuration Options

  version,
}:

mkMesonLibrary (finalAttrs: {
  pname = "nix-util-test-support";
  inherit version;

  workDir = ./.;

  propagatedBuildInputs = [
    nix-util
    nix-util-c
    rapidcheck
  ];

  mesonFlags = [
  ];

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
