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
  pname = "diffutils-static";
  version = "3.10";

  src = fetchurl {
    url = "mirror://gnu/diffutils/diffutils-${version}.tar.xz";
    hash = "sha256-kOXpPMck5OvhLt6A3xY0Bjx6hVaSaFkZv+YLVWyb0J4=";
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
      ${result}/bin/diff --version
      mkdir $out
    '';

  meta = with lib; {
    description = "Commands for showing the differences between files (diff, cmp, etc.)";
    homepage = "https://www.gnu.org/software/diffutils/diffutils.html";
    license = licenses.gpl3Only;
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.unix;
  };
} ''
  # Unpack
  tar xf ${src}
  cd diffutils-${version}

  # Configure
  bash ./configure \
    --prefix=$out \
    --build=${buildPlatform.config} \
    --host=${hostPlatform.config} \
    CC=musl-gcc \
    CFLAGS=-static \
    ac_cv_path_PR_PROGRAM=pr

  # Build
  make -j $NIX_BUILD_CORES

  # Install
  make -j $NIX_BUILD_CORES install
''
