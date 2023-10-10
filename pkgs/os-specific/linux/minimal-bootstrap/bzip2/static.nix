{
  lib,
  fetchurl,
  bash,
  gcc,
  musl,
  binutils,
  gnumake,
  gnutar,
  gzip,
}:
let
  pname = "bzip2-static";
  version = "1.0.8";

  src = fetchurl {
    url = "https://sourceware.org/pub/bzip2/bzip2-${version}.tar.gz";
    sha256 = "0s92986cv0p692icqlw1j42y9nld8zd83qwhzbqd61p1dqbh6nmb";
  };
in
bash.runCommand "${pname}-${version}"
  {
    inherit pname version;

    nativeBuildInputs = [
      gcc
      musl
      binutils
      gnumake
      gnutar
      gzip
    ];

    passthru.tests.get-version =
      result:
      bash.runCommand "${pname}-get-version-${version}" { } ''
        ${result}/bin/bzip2 --help
        mkdir $out
      '';

    meta = {
      description = "High-quality data compression program";
      homepage = "https://www.sourceware.org/bzip2";
      license = lib.licenses.bsdOriginal;
      platforms = lib.platforms.unix;
      teams = [ lib.teams.minimal-bootstrap ];
    };
  }
  ''
    # Unpack
    tar xf ${src}
    cd bzip2-${version}

    # Build
    make \
      -j $NIX_BUILD_CORES \
      CC=musl-gcc \
      CFLAGS=-static \
      bzip2 bzip2recover

    # Install
    make install -j $NIX_BUILD_CORES PREFIX=$out
  ''
