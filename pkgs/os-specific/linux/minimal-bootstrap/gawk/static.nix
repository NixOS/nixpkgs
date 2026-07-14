{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  gcc,
  binutils,
  gnumake,
  gnused,
  gnugrep,
  gawk,
  diffutils,
  findutils,
  gnutar,
  gzip,
}:
let
  inherit (import ./common.nix { inherit lib; }) meta;
  pname = "gawk-static";
  version = "5.3.2";

  src = fetchurl {
    url = "mirror://gnu/gawk/gawk-${version}.tar.gz";
    hash = "sha256-hjmhqI+0EaG+AmY3OdA+kCptMTtcb+Ak0L/rM0GhmhE=";
  };
in
bash.runCommand "${pname}-${version}"
  {
    inherit pname version meta;

    nativeBuildInputs = [
      gcc
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

    passthru.tests.get-version =
      result:
      bash.runCommand "${pname}-get-version-${version}" { } ''
        ${result}/bin/awk --version
        ${result}/bin/awk 'BEGIN { if (2 + 2 != 4) exit 1 }'
        mkdir $out
      '';
  }
  ''
    # Unpack
    tar xf ${src}
    cd gawk-${version}

    # Configure
    bash ./configure \
      --prefix=$out \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config} \
      --disable-dependency-tracking \
      --disable-extensions \
      --disable-mpfr \
      --disable-nls \
      --disable-pma

    # Build
    make -j $NIX_BUILD_CORES

    # Install
    make -j $NIX_BUILD_CORES install-strip
    rm $out/bin/gawkbug
    rm -rf $out/etc $out/include $out/lib $out/libexec
    rm -rf $out/share
  ''
