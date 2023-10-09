{ lib
, fetchurl
, bash
, gcc
, musl
, binutils
, gnumake
, gnused
, gnugrep
, gnutar
, xz
}:
let
  pname = "zlib";
  version = "1.3";

  src = fetchurl {
    url = "https://github.com/madler/zlib/releases/download/v${version}/zlib-${version}.tar.xz";
    hash = "sha256-ipuiiY4dDXdOymultGJ6EeVYi6hciFEzbrON5GgwUKc=";
  };
in
bash.runCommand "${pname}-${version}" {
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

  meta = with lib; {
    description = "Lossless data-compression library";
    homepage = "https://zlib.net";
    license = licenses.zlib;
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.unix;
  };
} ''
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
