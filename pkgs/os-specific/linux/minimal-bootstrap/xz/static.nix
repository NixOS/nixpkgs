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
  version = "5.8.3";

  src = fetchurl {
    url = "https://tukaani.org/xz/xz-${version}.tar.gz";
    hash = "sha256-PToblzryGBFPT4ibuqL0wDfequDI6BXuw4HD1Ua5dKA=";
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

    disallowedReferences = [ musl ];

    passthru.tests.get-version =
      result:
      bash.runCommand "${pname}-get-version-${version}" { } ''
        ${result}/bin/xz --version
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
    export CFLAGS="-g0 -O2 -DNDEBUG"
    export CXXFLAGS="$CFLAGS"
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
      --disable-scripts \
      --disable-doc \
      --disable-xzdec \
      --disable-lzmadec \
      --disable-lzmainfo \
      --disable-assembler

    # Build
    make -j $NIX_BUILD_CORES LDFLAGS=-all-static

    # Install
    make -j $NIX_BUILD_CORES install-strip
    rm -rf $out/include $out/lib $out/share
  ''
