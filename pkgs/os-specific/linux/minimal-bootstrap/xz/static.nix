{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  binutils,
  gcc,
  gnumake,
  gnused,
  gnugrep,
  gawk,
  gnutar,
  gzip,
  musl,
}:
let
  pname = "xz";
  version = "5.8.2";

  src = fetchurl {
    url = "https://tukaani.org/xz/xz-${version}.tar.gz";
    hash = "sha256-zgnFCllieGuD5do4nJDdLBXs0JgKJY3QH3D5585YqPE=";
  };
in
bash.runCommand "${pname}-${version}"
  {
    inherit pname version;

    nativeBuildInputs = [
      binutils
      gcc
      musl
      gnumake
      gnused
      gnugrep
      gawk
      gnutar
      gzip
    ];

    passthru.tests.get-version =
      result:
      bash.runCommand "${pname}-get-version-${version}" { } ''
        ${lib.getExe result} --version
        mkdir $out
      '';

    meta = {
      description = "General-purpose data compression software, successor of LZMA";
      homepage = "https://tukaani.org/xz";
      license = with lib.licenses; [
        gpl2Plus
        lgpl21Plus
      ];
      teams = [ lib.teams.minimal-bootstrap ];
      platforms = lib.platforms.unix;
      mainProgram = "xz";
    };
  }
  ''
    # Unpack
    tar xzf ${src}
    cd xz-${version}

    # Configure
    export CC=musl-gcc
    export CFLAGS=-static
    export CXXFLAGS=-static
    export LDFLAGS=-static
    bash ./configure \
      --prefix=$out \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config} \
      --disable-debug \
      --disable-dependency-tracking \
      --disable-silent-rules \
      --disable-nls \
      --disable-shared \
      --disable-assembler

    # Build
    make -j $NIX_BUILD_CORES

    # Install
    make -j $NIX_BUILD_CORES install
  ''
