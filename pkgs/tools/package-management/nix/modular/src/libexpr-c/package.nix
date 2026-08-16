{
  lib,
  mkMesonLibrary,

  nix-store-c,
  nix-expr,

  # Configuration Options

  version,
}:

mkMesonLibrary (finalAttrs: {
  pname = "nix-expr-c";
  inherit version;

  workDir = ./.;

  propagatedBuildInputs = [
    nix-store-c
    nix-expr
  ];

  mesonFlags = [
  ];

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
