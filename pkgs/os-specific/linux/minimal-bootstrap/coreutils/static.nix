{ lib
, buildPlatform
, hostPlatform
, fetchurl
, bash
, gcc
, musl
, binutils
, gnumake
, gnused
, gnugrep
, gawk
, diffutils
, findutils
, gnutar
, gzip
}:
let
  inherit (import ./common.nix { inherit lib; }) meta;
  pname = "coreutils-static";
  version = "9.4";

  src = fetchurl {
    url = "mirror://gnu/coreutils/coreutils-${version}.tar.gz";
    hash = "sha256-X2ANkJOXOwr+JTk9m8GMRPIjJlf0yg2V6jHHAutmtzk=";
  };

  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--build=${buildPlatform.config}"
    "--host=${hostPlatform.config}"
    # libstdbuf.so fails in static builds
    "--enable-no-install-program=stdbuf"
    "--enable-single-binary=symlinks"
    "CC=musl-gcc"
    "CFLAGS=-static"
  ];
in
bash.runCommand "${pname}-${version}" {
  inherit pname version meta;

  nativeBuildInputs = [
    gcc
    musl
    binutils
    gnumake
    gnused
    gnugrep
    gawk
    diffutils
    findutils
    gnutar
    gzip
  ];

  passthru.tests.get-version = result:
    bash.runCommand "${pname}-get-version-${version}" {} ''
      ${result}/bin/coreutils --version
      mkdir $out
    '';
} ''
  # Unpack
  tar xzf ${src}
  cd coreutils-${version}

  # Configure
  bash ./configure ${lib.concatStringsSep " " configureFlags}

  # Build
  make -j $NIX_BUILD_CORES

  # Install
  make -j $NIX_BUILD_CORES install
''
