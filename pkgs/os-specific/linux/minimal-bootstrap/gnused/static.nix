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
  inherit (import ./common.nix { inherit lib; }) meta;
  pname = "gnused-static";
  version = "4.9";

  src = fetchurl {
    url = "mirror://gnu/sed/sed-${version}.tar.xz";
    hash = "sha256-biJrcy4c1zlGStaGK9Ghq6QteYKSLaelNRljHSSXUYE=";
  };
in
bash.runCommand "${pname}-${version}" {
  inherit pname version meta;

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
      ${result}/bin/sed --version
      mkdir $out
    '';
} ''
  # Unpack
  tar xf ${src}
  cd sed-${version}

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
