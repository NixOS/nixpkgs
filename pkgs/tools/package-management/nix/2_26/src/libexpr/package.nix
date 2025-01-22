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

let
  inherit (lib) fileset;
in

mkMesonLibrary (finalAttrs: {
  pname = "nix-expr";
  inherit version;

  workDir = ./.;
  fileset = fileset.unions [
    ../../nix-meson-build-support
    ./nix-meson-build-support
    ../../.version
    ./.version
    ./meson.build
    ./meson.options
    ./primops/meson.build
    (fileset.fileFilter (file: file.hasExt "cc") ./.)
    (fileset.fileFilter (file: file.hasExt "hh") ./.)
    ./lexer.l
    ./parser.y
    (fileset.difference (fileset.fileFilter (file: file.hasExt "nix") ./.) ./package.nix)
  ];

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
  ] ++ finalAttrs.passthru.externalPropagatedBuildInputs;

  # Hack for sake of the dev shell
  passthru.externalPropagatedBuildInputs = [
    boost
    nlohmann_json
  ] ++ lib.optional enableGC boehmgc;

  preConfigure =
    # "Inline" .version so it's not a symlink, and includes the suffix.
    # Do the meson utils, without modification.
    ''
      chmod u+w ./.version
      echo ${version} > ../../.version
    '';

  mesonFlags = [
    (lib.mesonEnable "gc" enableGC)
  ];

  env = {
    # Needed for Meson to find Boost.
    # https://github.com/NixOS/nixpkgs/issues/86131.
    BOOST_INCLUDEDIR = "${lib.getDev boost}/include";
    BOOST_LIBRARYDIR = "${lib.getLib boost}/lib";
  };

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
