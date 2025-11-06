{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  gnumake,
  tinycc,
  gnused,
  gnugrep,
  gnutar,
  gzip,
}:

let
  inherit (import ./common.nix { inherit lib; }) meta;
  pname = "gnused";
  # last version that can be bootstrapped with our slightly buggy gnused-mes
  version = "4.2";

  src = fetchurl {
    url = "mirror://gnu/sed/sed-${version}.tar.gz";
    hash = "sha256-20XNY/0BDmUFN9ZdXfznaJplJ0UjZgbl5ceCk3Jn2YM=";
  };
in
bash.runCommand "${pname}-${version}"
  {
    inherit pname version meta;

    nativeBuildInputs = [
      gnumake
      tinycc.compiler
      gnused
      gnugrep
      gnutar
      gzip
    ];

    passthru.tests.get-version =
      result:
      bash.runCommand "${pname}-get-version-${version}" { } ''
        ${result}/bin/sed --version
        mkdir ''${out}
      '';
  }
  ''
    # Unpack
    tar xzf ${src}
    cd sed-${version}

    # Configure
    export CC="tcc -B ${tinycc.libs}/lib"
    export LD=tcc
    ./configure \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config} \
      --disable-shared \
      --disable-nls \
      --disable-dependency-tracking \
      --prefix=$out

    # Build
    make AR="tcc -ar"

    # Install
    make install
  ''
