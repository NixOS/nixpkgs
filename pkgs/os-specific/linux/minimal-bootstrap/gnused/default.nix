{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  coreutils,
  gnumake,
  tinycc,
  gnused,
  gnugrep,
  gnutar,
  gzip,
}:

let
  inherit (import ./common.nix { inherit lib; }) meta;
  pname = "gnused";
  # last version that can be bootstrapped with our slightly buggy gnused-mes
  version = "4.2";

  src = fetchurl {
    url = "mirror://gnu/sed/sed-${version}.tar.gz";
    hash = "sha256-20XNY/0BDmUFN9ZdXfznaJplJ0UjZgbl5ceCk3Jn2YM=";
  };

  # config.sub was generated with outdated autotools, which get confused by
  # 4-component target tuples
  fakeBuildPlatform = lib.strings.removeSuffix "-musl" buildPlatform.config;
  fakeHostPlatform = lib.strings.removeSuffix "-musl" hostPlatform.config;
in
bash.runCommand "${pname}-${version}"
  {
    inherit pname version meta;

    nativeBuildInputs = [
      coreutils
      gnumake
      tinycc.compiler
      gnused
      gnugrep
      gnutar
      gzip
    ];

    passthru.tests.get-version =
      result:
      bash.runCommand "${pname}-get-version-${version}" { } ''
        ${result}/bin/sed --version
        mkdir ''${out}
      '';
  }
  ''
    # Unpack
    tar xzf ${src}
    cd sed-${version}

    # Defeat parallel-build automake regen race: refresh generated-file
    # mtimes and restore +x on autotools helpers.
    touch Makefile.in Makefile aclocal.m4 config.h.in configure 2>/dev/null || true
    for f in */Makefile.in; do touch "$f" 2>/dev/null || true; done
    chmod +x configure config.guess config.sub install-sh missing compile \
      depcomp mkinstalldirs help2man 2>/dev/null || true
    [ -d build-aux ] && chmod +x build-aux/* 2>/dev/null || true

    # Configure
    export CC="tcc -B ${tinycc.libs}/lib"
    export LD=tcc
    ./configure \
      --build=${fakeBuildPlatform} \
      --host=${fakeHostPlatform} \
      --disable-shared \
      --disable-nls \
      --disable-dependency-tracking \
      --prefix=$out

    # Build
    # NOTE: parallel build (-j) under tcc-musl is unstable; keep serial.
    make AR="tcc -ar"

    # Install
    make install
  ''
