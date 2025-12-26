{
  lib,
  mkMesonLibrary,

  nix-store-c,
  nix-expr-c,
  nix-fetchers-c,
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
  ]
  ++ lib.optionals (lib.versionAtLeast version "2.29pre") [
    nix-fetchers-c
  ]
  ++ [
    nix-flake
  ];

  mesonFlags = [
  ];

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
