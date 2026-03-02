{
  lib,
  fetchurl,
  bash,
  gcc,
  musl,
  binutils,
  gnumake,
  gnused,
  gnugrep,
  gnutar,
  xz,
}:
let
  pname = "zlib";
  version = "1.3.1";

  src = fetchurl {
    url = "https://github.com/madler/zlib/releases/download/v${version}/zlib-${version}.tar.xz";
    hash = "sha256-OO+WuN/lENQnB9nHgYd5FHklQRM+GHCEFGO/pz+IPjI=";
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
      gnused
      gnugrep
      gnutar
      xz
    ];

    meta = {
      description = "Lossless data-compression library";
      homepage = "https://zlib.net";
      license = lib.licenses.zlib;
      platforms = lib.platforms.unix;
      teams = [ lib.teams.minimal-bootstrap ];
    };
  }
  ''
    # Unpack
    tar xf ${src}
    cd zlib-${version}

    # Configure
    export CC=musl-gcc
    bash ./configure --prefix=$out

    # Build
    make -j $NIX_BUILD_CORES

    # Install
    make -j $NIX_BUILD_CORES install
  ''
