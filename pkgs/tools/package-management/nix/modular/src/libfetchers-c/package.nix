{
  lib,
  mkMesonLibrary,

  nix-store-c,
  nix-expr-c,
  nix-util-c,
  nix-fetchers,

  # Configuration Options

  version,
}:

mkMesonLibrary (finalAttrs: {
  pname = "nix-fetchers-c";
  inherit version;

  workDir = ./.;

  propagatedBuildInputs = [
    nix-util-c
    nix-expr-c
    nix-store-c
    nix-fetchers
  ];

  mesonFlags = [ ];

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
