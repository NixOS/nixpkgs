{
  lib,
  stdenv,
  mkMesonLibrary,

  bison,
  flex,
  cmake, # for resolving toml11 dep

  nix-util,
  nix-store,
  nix-fetchers,
  boost,
  boehmgc,
  nlohmann_json,
  toml11,

  # Configuration Options

  version,

  # Whether to use garbage collection for the Nix language evaluator.
  #
  # If it is disabled, we just leak memory, but this is not as bad as it
  # sounds so long as evaluation just takes places within short-lived
  # processes. (When the process exits, the memory is reclaimed; it is
  # only leaked *within* the process.)
  #
  # Temporarily disabled on Windows because the `GC_throw_bad_alloc`
  # symbol is missing during linking.
  enableGC ? !stdenv.hostPlatform.isWindows,
}:

mkMesonLibrary (finalAttrs: {
  pname = "nix-expr";
  inherit version;

  workDir = ./.;

  nativeBuildInputs = [
    bison
    flex
    cmake
  ];

  buildInputs = [
    toml11
  ];

  propagatedBuildInputs = [
    nix-util
    nix-store
    nix-fetchers
    boost
    nlohmann_json
  ]
  ++ lib.optional enableGC boehmgc;

  mesonFlags = [
    (lib.mesonEnable "gc" enableGC)
  ];

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
