{
  lib,
  mkMesonLibrary,

  nix-store-test-support,
  nix-expr,
  nix-expr-c,

  rapidcheck,

  # Configuration Options

  version,
}:

mkMesonLibrary (finalAttrs: {
  pname = "nix-util-test-support";
  inherit version;

  workDir = ./.;

  propagatedBuildInputs = [
    nix-store-test-support
    nix-expr
    nix-expr-c
    rapidcheck
  ];

  mesonFlags = [
  ];

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
