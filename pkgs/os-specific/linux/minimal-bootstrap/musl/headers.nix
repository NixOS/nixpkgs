{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  gcc,
  binutils,
  gnumake,
  gnugrep,
  gnused,
  gnutar,
  gzip,
}:
let
  inherit (import ./common.nix { inherit lib; }) pname meta;
  version = "1.2.5";

  src = fetchurl {
    url = "https://musl.libc.org/releases/musl-${version}.tar.gz";
    hash = "sha256-qaEYu+hNh2TaDqDSizqz+uhHf8fkCF2QECuFlvx8deQ=";
  };
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
      gnutar
      gzip
    ];
  }
  ''
    # Unpack
    tar xzf ${src}
    cd musl-${version}

    # Patch
    # https://github.com/ZilchOS/bootstrap-from-tcc/blob/2e0c68c36b3437386f786d619bc9a16177f2e149/using-nix/2a3-intermediate-musl.nix
    sed -i 's|/bin/sh|${bash}/bin/bash|' \
      tools/*.sh

    # Configure
    # Use build-gcc, since we won't be compiling anything
    bash ./configure \
      --prefix=$out \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config} \
      --syslibdir=$out/lib \
      --enable-wrapper \
      CC=gcc

    # Install
    make -j $NIX_BUILD_CORES install-headers
  ''
