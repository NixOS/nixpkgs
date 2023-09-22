{ lib
, buildPlatform
, hostPlatform
, fetchurl
, bash
, tinycc
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
  version = "5.2.0";

  src = fetchurl {
    url = "mirror://gnu/gawk/gawk-${version}.tar.gz";
    hash = "sha256-71r0RJywJp+vOvJL9MAic9RV8HQb88UPht3AkzLWz1Y=";
  };
in
bash.runCommand "${pname}-${version}" {
  inherit pname version meta;

  nativeBuildInputs = [
    tinycc.compiler
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
  export CC="tcc -B ${tinycc.libs}/lib"
  export AR="tcc -ar"
  export LD=tcc
  bash ./configure \
    --prefix=$out \
    --build=${buildPlatform.config} \
    --host=${hostPlatform.config}

  # Build
  make

  # Install
  make install
''
