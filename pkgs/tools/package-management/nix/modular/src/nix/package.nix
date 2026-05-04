{
  lib,
  mkMesonExecutable,
  stdenv,

  nix-store,
  nix-expr,
  nix-main,
  nix-cmd,

  mimalloc,

  # Configuration Options

  version,

  # Whether to link against mimalloc for malloc override.
  # Significantly improves evaluation performance on allocation-heavy
  # workloads (~10-15% on large evaluations).
  withMimalloc ? ((lib.versionAtLeast version "2.35pre") && !stdenv.hostPlatform.isWindows),
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
  ++ lib.optional withMimalloc mimalloc;

  mesonFlags = lib.optionals withMimalloc [
    (lib.mesonEnable "mimalloc" withMimalloc)
  ];

  meta = {
    mainProgram = "nix";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
