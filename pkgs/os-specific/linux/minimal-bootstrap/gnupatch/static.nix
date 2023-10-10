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
  pname = "gnupatch-static";
  version = "2.7";

  src = fetchurl {
    url = "mirror://gnu/patch/patch-${version}.tar.xz";
    hash = "sha256-XCyR/kFUKWISbwvhUKpPo0lIXPLtwMfqfbwky4FxEa4=";
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
      ${result}/bin/patch --version
      mkdir $out
    '';

  meta = with lib; {
    description = "GNU Patch, a program to apply differences to files";
    homepage = "https://www.gnu.org/software/patch";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    mainProgram = "patch";
    platforms = platforms.unix;
  };
} ''
  # Unpack
  tar xf ${src}
  cd patch-${version}

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
''
