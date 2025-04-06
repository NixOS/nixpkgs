{
  lib,
  stdenv,
  mkMesonLibrary,

  boost,
  brotli,
  libarchive,
  libblake3,
  libcpuid,
  libsodium,
  nlohmann_json,
  openssl,

  # Configuration Options

  version,
}:

let
  inherit (lib) fileset;
in

mkMesonLibrary (finalAttrs: {
  pname = "nix-util";
  inherit version;

  workDir = ./.;
  fileset = fileset.unions [
    ../../nix-meson-build-support
    ./nix-meson-build-support
    ../../.version
    ./.version
    ./widecharwidth
    ./meson.build
    ./meson.options
    ./linux/meson.build
    ./unix/meson.build
    ./windows/meson.build
    (fileset.fileFilter (file: file.hasExt "cc") ./.)
    (fileset.fileFilter (file: file.hasExt "hh") ./.)
  ];

  buildInputs =
    [
      brotli
    ]
    ++ lib.optional (lib.versionAtLeast version "2.27") [
      libblake3
    ]
    ++ [
      libsodium
      openssl
    ]
    ++ lib.optional stdenv.hostPlatform.isx86_64 libcpuid;

  propagatedBuildInputs = [
    boost
    libarchive
    nlohmann_json
  ];

  mesonFlags = [
    (lib.mesonEnable "cpuid" stdenv.hostPlatform.isx86_64)
  ];

  env = lib.optionalAttrs (!lib.versionAtLeast version "2.27") {
    # Needed for Meson to find Boost.
    # https://github.com/NixOS/nixpkgs/issues/86131.
    BOOST_INCLUDEDIR = "${lib.getDev boost}/include";
    BOOST_LIBRARYDIR = "${lib.getLib boost}/lib";
  };

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
