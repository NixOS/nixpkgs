{ lib
, buildPlatform
, hostPlatform
, fetchurl
, bash
, gcc
, musl
, binutils
, gnumake
, gnused
, gnugrep
, gawk
, diffutils
, findutils
, gnutar
, xz
}:
let
  pname = "findutils-static";
  version = "4.9.0";

  src = fetchurl {
    url = "mirror://gnu/findutils/findutils-${version}.tar.xz";
    hash = "sha256-or+4wJ1DZ3DtxZ9Q+kg+eFsWGjt7nVR1c8sIBl/UYv4=";
  };
in
bash.runCommand "${pname}-${version}" {
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
  tar xf ${src}
  cd findutils-${version}

  # Configure
  bash ./configure \
    --prefix=$out \
    --build=${buildPlatform.config} \
    --host=${hostPlatform.config} \
    CC=musl-gcc \
    CFLAGS=-static

  # Build
  make -j $NIX_BUILD_CORES

  # Install
  make -j $NIX_BUILD_CORES install
  rm $out/bin/updatedb
''
