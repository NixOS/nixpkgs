{
  lib,
  mkMesonExecutable,

  nix-store,
  nix-expr,
  nix-main,
  nix-cmd,

  # Configuration Options

  version,
}:

mkMesonExecutable (finalAttrs: {
  pname = "nix";
  inherit version;

  workDir = ./.;

  buildInputs = [
    nix-store
    nix-expr
    nix-main
    nix-cmd
  ];

  mesonFlags = [
  ];

  meta = {
    mainProgram = "nix";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
