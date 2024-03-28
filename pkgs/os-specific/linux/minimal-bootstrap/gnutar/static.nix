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
, gnutarBoot
, gzip
}:
let
  inherit (import ./common.nix { inherit lib; }) meta;
  pname = "gnutar-static";
  version = "1.35";

  src = fetchurl {
    url = "mirror://gnu/tar/tar-${version}.tar.gz";
    hash = "sha256-FNVeMgY+qVJuBX+/Nfyr1TN452l4fv95GcN1WwLStX4=";
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
    gnutarBoot
    gzip
  ];

  passthru.tests.get-version = result:
    bash.runCommand "${pname}-get-version-${version}" {} ''
      ${result}/bin/tar --version
      mkdir $out
    '';
} ''
  # Unpack
  tar xzf ${src}
  cd tar-${version}

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
