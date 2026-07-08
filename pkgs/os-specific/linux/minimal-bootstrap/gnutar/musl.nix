{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  coreutils,
  tinycc,
  gnumake,
  gnugrep,
  gnused,
}:
let
  # gnutar with musl preserves modify times, allowing make to not try
  # rebuilding pregenerated files
  inherit (import ./common.nix { inherit lib; }) meta;
  pname = "gnutar-musl";
  version = "1.12";

  src = fetchurl {
    url = "mirror://gnu/tar/tar-${version}.tar.gz";
    hash = "sha256-xsN+iIsTbM76uQPFEUn0t71lnWnUrqISRfYQU6V6pgo=";
  };
in
bash.runCommand "${pname}-${version}"
  {
    inherit pname version meta;

    nativeBuildInputs = [
      coreutils
      tinycc.compiler
      gnumake
      gnused
      gnugrep
    ];

    passthru.tests.get-version =
      result:
      bash.runCommand "${pname}-get-version-${version}" { } ''
        ${result}/bin/tar --version
        mkdir $out
      '';
  }
  ''
    # Unpack
    ungz --file ${src} --output tar.tar
    untar --file tar.tar
    rm tar.tar
    cd tar-${version}

    # untar drops mtimes and +x on autotools helpers, restore them so
    # parallel builds don't trip into automake regeneration.
    touch Makefile.in Makefile aclocal.m4 config.h.in configure 2>/dev/null || true
    for f in */Makefile.in; do touch "$f" 2>/dev/null || true; done
    chmod +x configure config.guess config.sub install-sh missing compile \
      depcomp mkinstalldirs help2man 2>/dev/null || true
    [ -d build-aux ] && chmod +x build-aux/* 2>/dev/null || true

    # Configure
    export CC="tcc -B ${tinycc.libs}/lib"
    export LD=tcc
    export ac_cv_sizeof_unsigned_long=4
    export ac_cv_sizeof_long_long=8
    export ac_cv_header_netdb_h=no
    bash ./configure \
      --prefix=$out \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config} \
      --disable-dependency-tracking \
      --disable-nls

    # Build
    # NOTE: parallel build (-j) under tcc-musl is unstable; keep serial.
    make AR="tcc -ar"

    # Install
    make install
  ''
