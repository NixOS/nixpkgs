{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  gcc,
  musl,
  binutils,
  gnumake,
  gnused,
  gnugrep,
  gawk,
  diffutils,
  findutils,
  gnutar,
  xz,
}:
let
  pname = "gzip-static";
  version = "1.14";

  src = fetchurl {
    url = "mirror://gnu/gzip/gzip-${version}.tar.xz";
    hash = "sha256-Aae4gb0iC/32Ffl7hxj4C9/T9q3ThbmT3Pbv0U6MCsY=";
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
      gawk
      diffutils
      findutils
      gnutar
      xz
    ];

    passthru.tests.get-version =
      result:
      bash.runCommand "${pname}-get-version-${version}" { } ''
        ${result}/bin/gzip --version
        mkdir $out
      '';

    meta = {
      description = "GNU zip compression program";
      homepage = "https://www.gnu.org/software/gzip";
      license = lib.licenses.gpl3Plus;
      platforms = lib.platforms.unix;
      teams = [ lib.teams.minimal-bootstrap ];
    };
  }
  ''
    # Unpack
    tar xf ${src}
    cd gzip-${version}

    # Configure
    bash ./configure \
      --prefix=$out \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config} \
      --disable-dependency-tracking \
      CC=musl-gcc \
      CFLAGS=-static

    # Build
    make -j $NIX_BUILD_CORES bin_SCRIPTS=

    # Install
    make -j $NIX_BUILD_CORES bin_SCRIPTS= install
  ''
