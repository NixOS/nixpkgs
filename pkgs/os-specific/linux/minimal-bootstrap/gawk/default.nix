{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  tinycc,
  gnumake,
  gnugrep,
  gnupatch,
  gnused,
  gnutar,
  gzip,
  bootGawk,
}:
let
  inherit (import ./common.nix { inherit lib; }) meta;
  pname = "gawk";

  version = "5.4.2";

  src = fetchurl {
    url = "mirror://gnu/gawk/gawk-${version}.tar.gz";
    hash = "sha256-ecRvXeFEAWY8Y8jfT8RcO9p29jKdc7ITUjp8cfMvckM=";
  };
in
bash.runCommand "${pname}-${version}"
  {
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

    passthru.tests.get-version =
      result:
      bash.runCommand "${pname}-get-version-${version}" { } ''
        ${result}/bin/awk --version
        mkdir $out
      '';
  }
  ''
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
      --host=${hostPlatform.config} \
      --disable-dependency-tracking

    # Build
    make -j $NIX_BUILD_CORES

    # Install
    make -j $NIX_BUILD_CORES install
  ''
