{ lib
, buildPlatform
, hostPlatform
, fetchurl
, bash
, tinycc
, gnumake
, gnugrep
, gnused
, gawk
, gnutar
, xz
}:
let
  pname = "findutils";
  version = "4.9.0";

  src = fetchurl {
    url = "mirror://gnu/findutils/findutils-${version}.tar.xz";
    hash = "sha256-or+4wJ1DZ3DtxZ9Q+kg+eFsWGjt7nVR1c8sIBl/UYv4=";
  };
in
bash.runCommand "${pname}-${version}" {
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

  passthru.tests.get-version = result:
    bash.runCommand "${pname}-get-version-${version}" {} ''
      ${result}/bin/find --version
      mkdir $out
    '';

  meta = with lib; {
    description = "GNU Find Utilities, the basic directory searching utilities of the GNU operating system";
    homepage = "https://www.gnu.org/software/findutils";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.unix;
  };
} ''
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
    --host=${hostPlatform.config}

  # Build
  make -j $NIX_BUILD_CORES

  # Install
  make -j $NIX_BUILD_CORES install
''
