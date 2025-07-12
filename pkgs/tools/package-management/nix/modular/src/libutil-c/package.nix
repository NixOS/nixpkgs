{
  lib,
  mkMesonLibrary,

  nix-util,

  # Configuration Options

  version,
}:

mkMesonLibrary (finalAttrs: {
  pname = "nix-util-c";
  inherit version;

  workDir = ./.;

  propagatedBuildInputs = [
    nix-util
  ];

  mesonFlags = [
  ];

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
