{
  lib,
  mkMesonLibrary,

  openssl,

  nix-util,
  nix-store,
  nix-expr,

  # Configuration Options

  version,
}:

mkMesonLibrary (finalAttrs: {
  pname = "nix-main";
  inherit version;

  workDir = ./.;

  propagatedBuildInputs =
    lib.optionals (lib.versionAtLeast version "2.28") [
      nix-expr
    ]
    ++ [
      nix-util
      nix-store
      openssl
    ];

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
