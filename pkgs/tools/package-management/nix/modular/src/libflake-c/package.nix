{
  lib,
  mkMesonLibrary,

  nix-store-c,
  nix-expr-c,
  nix-flake,

  # Configuration Options

  version,
}:

mkMesonLibrary (finalAttrs: {
  pname = "nix-flake-c";
  inherit version;

  workDir = ./.;

  propagatedBuildInputs = [
    nix-expr-c
    nix-store-c
    nix-flake
  ];

  mesonFlags = [
  ];

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
