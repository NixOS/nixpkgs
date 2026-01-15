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
  pname = "gnum4";
  version = "1.4.20";

  src = fetchurl {
    url = "mirror://gnu/m4/m4-${version}.tar.xz";
    hash = "sha256-4jbqOhzPX2wnCxxLtgcm83H6SUWajqrryQshazKNrys=";
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
        ${result}/bin/m4 --version
        mkdir $out
      '';

    meta = {
      description = "GNU M4, a macro processor";
      homepage = "https://www.gnu.org/software/m4/";
      license = lib.licenses.gpl3Plus;
      platforms = lib.platforms.unix;
      mainProgram = "m4";
      teams = [ lib.teams.minimal-bootstrap ];
    };
  }
  ''
    # Unpack
    tar xf ${src}
    cd m4-${version}

    # Configure
    bash ./configure \
      --prefix=$out \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config} \
      --disable-dependency-tracking \
      CC=musl-gcc

    # Build
    make -j $NIX_BUILD_CORES

    # Install
    make -j $NIX_BUILD_CORES install
  ''
