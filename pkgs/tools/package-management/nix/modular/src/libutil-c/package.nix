{
  lib,
  mkMesonLibrary,

  nix-util,

  # Configuration Options

  version,
  withPluginCAPI,
}:

mkMesonLibrary (finalAttrs: {
  pname = "nix-util-c";
  inherit version;

  workDir = ./.;

  propagatedBuildInputs = [
    nix-util
  ];

  mesonFlags = lib.optional (lib.versionAtLeast (lib.versions.majorMinor version) "2.35") (
    lib.mesonBool "plugin-c-api" withPluginCAPI
  );

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
