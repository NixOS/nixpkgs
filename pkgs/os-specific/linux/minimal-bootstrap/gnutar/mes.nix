{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  coreutils,
  tinycc,
  gnumake,
  gnused,
  gnugrep,
}:
let
  inherit (import ./common.nix { inherit lib; }) meta;
  pname = "gnutar";
  # >= 1.13 is incompatible with mes-libc
  version = "1.12";

  src = fetchurl {
    url = "mirror://gnu/tar/tar-${version}.tar.gz";
    sha256 = "02m6gajm647n8l9a5bnld6fnbgdpyi4i3i83p7xcwv0kif47xhy6";
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
    bash ./configure \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config} \
      --disable-dependency-tracking \
      --disable-nls \
      --prefix=$out

    # Build
    # NOTE: parallel build (-j) breaks gnutar build under tcc-mes; keep serial.
    make AR="tcc -ar"

    # Install
    make install
  ''
