{
  lib,
  mkMesonLibrary,

  nix-util-c,
  nix-store-c,
  nix-expr-c,
  nix-cmd,

  # Configuration Options

  version,
}:

mkMesonLibrary (finalAttrs: {
  pname = "nix-cmd-c";
  inherit version;

  workDir = ./.;

  propagatedBuildInputs = [
    nix-util-c
    nix-store-c
    nix-expr-c
    nix-cmd
  ];

  mesonFlags = [ ];

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
