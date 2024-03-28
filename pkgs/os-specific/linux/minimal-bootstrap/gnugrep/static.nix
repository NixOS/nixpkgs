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
  pname = "gnugrep-static";
  version = "3.11";

  src = fetchurl {
    url = "mirror://gnu/grep/grep-${version}.tar.xz";
    hash = "sha256-HbKu3eidDepCsW2VKPiUyNFdrk4ZC1muzHj1qVEnbqs=";
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
      ${result}/bin/grep --version
      mkdir $out
    '';

  meta = with lib; {
    description = "GNU implementation of the Unix grep command";
    homepage = "https://www.gnu.org/software/grep";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    mainProgram = "grep";
    platforms = platforms.unix;
  };
} ''
  # Unpack
  tar xf ${src}
  cd grep-${version}

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
  rm $out/bin/{egrep,fgrep}
''
