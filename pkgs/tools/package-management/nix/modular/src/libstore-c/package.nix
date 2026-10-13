{
  lib,
  mkMesonLibrary,

  nix-util-c,
  nix-store,

  # Configuration Options

  version,
  withPluginCAPI,
}:

mkMesonLibrary (finalAttrs: {
  pname = "nix-store-c";
  inherit version;

  workDir = ./.;

  propagatedBuildInputs = [
    nix-util-c
    nix-store
  ];

  mesonFlags = lib.optional (lib.versionAtLeast (lib.versions.majorMinor version) "2.35") (
    lib.mesonBool "plugin-c-api" withPluginCAPI
  );

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
