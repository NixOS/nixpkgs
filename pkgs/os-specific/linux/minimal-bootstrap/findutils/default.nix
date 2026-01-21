{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  tinycc,
  gnumake,
  gnugrep,
  gnused,
  gawk,
  gnutar,
  xz,
}:
let
  pname = "findutils";
  version = "4.10.0";

  src = fetchurl {
    url = "mirror://gnu/findutils/findutils-${version}.tar.xz";
    hash = "sha256-E4fgtn/yR9Kr3pmPkN+/cMFJE5Glnd/suK5ph4nwpPU=";
  };
in
bash.runCommand "${pname}-${version}"
  {
    inherit pname version;

    nativeBuildInputs = [
      tinycc.compiler
      gnumake
      gnused
      gnugrep
      gawk
      gnutar
      xz
    ];

    passthru.tests.get-version =
      result:
      bash.runCommand "${pname}-get-version-${version}" { } ''
        ${result}/bin/find --version
        mkdir $out
      '';

    meta = {
      description = "GNU Find Utilities, the basic directory searching utilities of the GNU operating system";
      homepage = "https://www.gnu.org/software/findutils";
      license = lib.licenses.gpl3Plus;
      teams = [ lib.teams.minimal-bootstrap ];
      platforms = lib.platforms.unix;
    };
  }
  ''
    # Unpack
    cp ${src} findutils.tar.xz
    unxz findutils.tar.xz
    tar xf findutils.tar
    rm findutils.tar
    cd findutils-${version}

    # Patch
    # configure fails to accurately detect PATH_MAX support
    sed -i 's/chdir_long/chdir/' gl/lib/save-cwd.c

    # Configure
    export CC="tcc -B ${tinycc.libs}/lib"
    export AR="tcc -ar"
    export LD=tcc
    bash ./configure \
      --prefix=$out \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config} \
      --disable-dependency-tracking

    # Build
    make -j $NIX_BUILD_CORES

    # Install
    make -j $NIX_BUILD_CORES install
  ''
