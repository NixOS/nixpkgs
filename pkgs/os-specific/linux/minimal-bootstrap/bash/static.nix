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
, gzip
}:
let
  inherit (import ./common.nix { inherit lib; }) meta;
  pname = "bash-static";
  version = "5.2.15";

  src = fetchurl {
    url = "mirror://gnu/bash/bash-${version}.tar.gz";
    sha256 = "132qng0jy600mv1fs95ylnlisx2wavkkgpb19c6kmz7lnmjhjwhk";
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
    gzip
  ];

  passthru.tests.get-version = result:
    bash.runCommand "${pname}-get-version-${version}" {} ''
      ${result}/bin/bash --version
      mkdir $out
    '';
} ''
  # Unpack
  tar xf ${src}
  cd bash-${version}

  # Configure
  bash ./configure \
    --prefix=$out \
    --build=${buildPlatform.config} \
    --host=${hostPlatform.config} \
    --without-bash-malloc \
    --enable-static-link \
    bash_cv_func_strtoimax=y \
    CC=musl-gcc

  # Build
  make -j $NIX_BUILD_CORES

  # Install
  make -j $NIX_BUILD_CORES install-strip
  rm $out/bin/bashbug
''
