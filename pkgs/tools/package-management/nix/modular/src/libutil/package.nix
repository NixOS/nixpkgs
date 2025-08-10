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

mkMesonLibrary (finalAttrs: {
  pname = "nix-util";
  inherit version;

  workDir = ./.;

  buildInputs = [
    brotli
  ]
  ++ lib.optional (lib.versionAtLeast version "2.27") libblake3
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

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
