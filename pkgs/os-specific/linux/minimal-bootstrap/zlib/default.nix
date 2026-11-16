{
  lib,
  fetchurl,
  bash,
  gcc,
  binutils,
  gnumake,
  gnused,
  gnugrep,
  gnutar,
  xz,
}:
let
  pname = "zlib";
  version = "1.4";

  src = fetchurl {
    url = "https://github.com/madler/zlib/releases/download/v${version}/zlib-${version}.tar.xz";
    hash = "sha256-TxHFEgU9e6uNnpuJveNXWt0+TFCjg7Qu9suDcDX8Wnw=";
  };
in
bash.runCommand "${pname}-${version}"
  {
    inherit pname version;

    nativeBuildInputs = [
      gcc
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
    bash ./configure --prefix=$out

    # Build
    make -j $NIX_BUILD_CORES

    # Install
    make -j $NIX_BUILD_CORES install
  ''
