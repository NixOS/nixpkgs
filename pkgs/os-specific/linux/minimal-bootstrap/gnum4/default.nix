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
  pname = "gnum4";
  version = "1.4.19";

  src = fetchurl {
    url = "mirror://gnu/m4/m4-${version}.tar.xz";
    hash = "sha256-Y67eXG0zttmxNRHNC+LKwEby5w/QoHqpVzoEqCeDr5Y=";
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
      ${result}/bin/m4 --version
      mkdir $out
    '';

  meta = with lib; {
    description = "GNU M4, a macro processor";
    homepage = "https://www.gnu.org/software/m4/";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.unix;
    mainProgram = "m4";
  };
} ''
  # Unpack
  tar xf ${src}
  cd m4-${version}

  # Configure
  bash ./configure \
    --prefix=$out \
    --build=${buildPlatform.config} \
    --host=${hostPlatform.config} \
    CC=musl-gcc

  # Build
  make -j $NIX_BUILD_CORES

  # Install
  make -j $NIX_BUILD_CORES install
''
