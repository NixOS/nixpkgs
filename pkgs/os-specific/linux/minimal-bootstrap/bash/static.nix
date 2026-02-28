{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  gcc-buildbuild,
  gcc,
  binutils,
  gnumake,
  gnused,
  gnugrep,
  gawk,
  diffutils,
  findutils,
  gnutar,
  gzip,
}:
let
  inherit (import ./common.nix { inherit lib; }) meta;
  pname = "bash-static";
  version = "5.3";

  src = fetchurl {
    url = "mirror://gnu/bash/bash-${version}.tar.gz";
    sha256 = "sha256-DVzYaWX4aaJs9k9Lcb57lvkKO6iz104n6OnZ1VUPMbo=";
  };

  binutilsTargetPrefix = lib.optionalString (
    hostPlatform.config != buildPlatform.config
  ) "${hostPlatform.config}-";
in
bash.runCommand "${pname}-${version}"
  {
    inherit pname version meta;

    nativeBuildInputs = [
      gcc
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

    passthru.tests.get-version =
      result:
      bash.runCommand "${pname}-get-version-${version}" { } ''
        ${result}/bin/bash --version
        mkdir $out
      '';
  }
  ''
    # Unpack
    tar xf ${src}
    cd bash-${version}

    export AR="${binutilsTargetPrefix}ar"
    export STRIP="${binutilsTargetPrefix}strip"
    export STRIPPROG="$STRIP"

    # Configure
    bash ./configure \
      --prefix=$out \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config} \
      --without-bash-malloc \
      --disable-dependency-tracking \
      --enable-static-link \
      CC_FOR_BUILD=${gcc-buildbuild}/bin/gcc

    # Build
    make -j $NIX_BUILD_CORES

    # Install
    make -j $NIX_BUILD_CORES install-strip
    rm $out/bin/bashbug
    ln -s $out/bin/bash $out/bin/sh
  ''
