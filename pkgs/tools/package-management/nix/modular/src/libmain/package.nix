{
  lib,
  mkMesonLibrary,

  openssl,

  nix-util,
  nix-store,

  # Configuration Options

  version,
}:

mkMesonLibrary (finalAttrs: {
  pname = "nix-main";
  inherit version;

  workDir = ./.;

  propagatedBuildInputs = [
    nix-util
    nix-store
    openssl
  ];

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
