{
  lib,
  mkMesonLibrary,

  nix-util,
  nix-store,
  nlohmann_json,
  libgit2,

  # Configuration Options

  version,
}:

mkMesonLibrary (finalAttrs: {
  pname = "nix-fetchers";
  inherit version;

  workDir = ./.;

  buildInputs = [
    libgit2
  ];

  propagatedBuildInputs = [
    nix-store
    nix-util
    nlohmann_json
  ];

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
