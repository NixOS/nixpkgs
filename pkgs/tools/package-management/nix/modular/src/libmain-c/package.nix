{
  lib,
  mkMesonLibrary,

  nix-util-c,
  nix-store,
  nix-store-c,
  nix-main,

  # Configuration Options

  version,
}:

mkMesonLibrary (finalAttrs: {
  pname = "nix-main-c";
  inherit version;

  workDir = ./.;

  propagatedBuildInputs = [
    nix-util-c
    nix-store
    nix-store-c
    nix-main
  ];

  mesonFlags = [
  ];

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
