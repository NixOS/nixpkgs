{
  lib,
  mkMesonLibrary,

  nix-util,
  nix-store,
  nix-fetchers,
  nix-expr,
  nlohmann_json,

  # Configuration Options

  version,
}:

mkMesonLibrary (finalAttrs: {
  pname = "nix-flake";
  inherit version;

  workDir = ./.;

  propagatedBuildInputs = [
    nix-store
    nix-util
    nix-fetchers
    nix-expr
    nlohmann_json
  ];

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
