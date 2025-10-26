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
  pname = "diffutils-static";
  version = "3.12";

  src = fetchurl {
    url = "mirror://gnu/diffutils/diffutils-${version}.tar.xz";
    hash = "sha256-fIt/n8hgkUH96pzs6FJJ0whiQ5H/Yd7a9Sj8szdyff0=";
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
        ${result}/bin/diff --version
        mkdir $out
      '';

    meta = {
      description = "Commands for showing the differences between files (diff, cmp, etc.)";
      homepage = "https://www.gnu.org/software/diffutils/diffutils.html";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.unix;
      teams = [ lib.teams.minimal-bootstrap ];
    };
  }
  ''
    # Unpack
    tar xf ${src}
    cd diffutils-${version}

    # Configure
    bash ./configure \
      --prefix=$out \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config} \
      --disable-dependency-tracking \
      CC=musl-gcc \
      CFLAGS=-static \
      ac_cv_path_PR_PROGRAM=pr

    # Build
    make -j $NIX_BUILD_CORES

    # Install
    make -j $NIX_BUILD_CORES install
  ''
