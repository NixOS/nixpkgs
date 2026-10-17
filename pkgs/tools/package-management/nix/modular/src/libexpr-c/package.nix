{
  lib,
  mkMesonLibrary,

  nix-store-c,
  nix-expr,

  # Configuration Options

  version,
  withPluginCAPI,
}:

mkMesonLibrary (finalAttrs: {
  pname = "nix-expr-c";
  inherit version;

  workDir = ./.;

  propagatedBuildInputs = [
    nix-store-c
    nix-expr
  ];

  mesonFlags = lib.optional (lib.versionAtLeast (lib.versions.majorMinor version) "2.35") (
    lib.mesonBool "plugin-c-api" withPluginCAPI
  );

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
