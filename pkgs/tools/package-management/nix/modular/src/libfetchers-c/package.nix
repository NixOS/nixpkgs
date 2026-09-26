{
  lib,
  mkMesonLibrary,

  nix-store-c,
  nix-expr-c,
  nix-util-c,
  nix-fetchers,

  # Configuration Options

  version,
  withPluginCAPI,
}:

mkMesonLibrary (finalAttrs: {
  pname = "nix-fetchers-c";
  inherit version;

  workDir = ./.;

  propagatedBuildInputs = [
    nix-util-c
    nix-expr-c
    nix-store-c
    nix-fetchers
  ];

  mesonFlags = lib.optional (lib.versionAtLeast (lib.versions.majorMinor version) "2.35") (
    lib.mesonBool "plugin-c-api" withPluginCAPI
  );

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
