{
  lib,
  mkMesonExecutable,
  stdenv,

  nix-store,
  nix-expr,
  nix-main,
  nix-cmd,

  nix-expr-c,
  nix-fetchers-c,
  nix-flake-c,
  nix-main-c,
  nix-store-c,
  nix-util-c,

  mimalloc,

  # Configuration Options

  version,

  # Whether to link against mimalloc for malloc override.
  # Significantly improves evaluation performance on allocation-heavy
  # workloads (~10-15% on large evaluations).
  withMimalloc ? !stdenv.hostPlatform.isWindows,

  # Whether to embed the public C API into the `nix` executable so plugins can
  # resolve those symbols without linking Nix libraries directly.
  withPluginCApi ? !stdenv.hostPlatform.isWindows && !stdenv.hostPlatform.isStatic,
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
  ]
  ++ lib.optionals ((lib.versionAtLeast (lib.versions.majorMinor version) "2.35") && withPluginCApi) [
    nix-expr-c
    nix-fetchers-c
    nix-flake-c
    nix-main-c
    nix-store-c
    nix-util-c
  ]
  ++ lib.optional ((lib.versionAtLeast version "2.35pre") && withMimalloc) mimalloc;

  mesonFlags =
    lib.optionals (lib.versionAtLeast version "2.35pre") [
      (lib.mesonEnable "mimalloc" withMimalloc)
    ]
    ++ lib.optional (lib.versionAtLeast (lib.versions.majorMinor version) "2.35") (
      lib.mesonBool "plugin-c-api" withPluginCApi
    );

  passthru = {
    exportsPluginCApi = withPluginCApi;
  };

  meta = {
    mainProgram = "nix";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
