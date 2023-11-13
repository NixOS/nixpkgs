{ lib
, buildPlatform
, hostPlatform
, fetchurl
, bash
, gcc
, glibc
, binutils
, linux-headers
, gnumake
, gnugrep
, gnused
, gnutar
, gzip
, bootGawk
}:
let
  inherit (import ./common.nix { inherit lib; }) meta;
  pname = "gawk";
  # >= 4.2.0 fails to cleanly build. may be worth investigating in the future.
  # for now this version is sufficient to build glibc 2.16
  version = "4.1.4";

  src = fetchurl {
    url = "mirror://gnu/gawk/gawk-${version}.tar.gz";
    sha256 = "0dadjkpyyizmyd0l098qps8lb39r0vrz3xl3hwz2cmjs5c70h0wc";
  };
in
bash.runCommand "${pname}-${version}" {
  inherit pname version meta;

  nativeBuildInputs = [
    gcc
    binutils
    gnumake
    gnused
    gnugrep
    gnutar
    gzip
    bootGawk
  ];

  passthru.tests.get-version = result:
    bash.runCommand "${pname}-get-version-${version}" {} ''
      ${result}/bin/awk --version
      mkdir $out
    '';
} ''
  # Unpack
  tar xzf ${src}
  cd gawk-${version}

  # Configure
  export C_INCLUDE_PATH="${glibc}/include:${linux-headers}/include"
  export LIBRARY_PATH="${glibc}/lib"
  export LIBS="-lc -lnss_files -lnss_dns -lresolv"
  bash ./configure \
    --prefix=$out \
    --build=${buildPlatform.config} \
    --host=${hostPlatform.config}

  # Build
  make gawk

  # Install
  install -D gawk $out/bin/gawk
  ln -s gawk $out/bin/awk
''
