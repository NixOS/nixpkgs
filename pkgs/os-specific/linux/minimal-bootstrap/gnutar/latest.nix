{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  gcc,
  musl,
  binutils,
  gnumake,
  gnused,
  gnugrep,
  gawk,
  gzip,
  gnutarBoot,
}:
let
  pname = "gnutar";
  version = "1.35";

  src = fetchurl {
    url = "mirror://gnu/tar/tar-${version}.tar.gz";
    hash = "sha256-FNVeMgY+qVJuBX+/Nfyr1TN452l4fv95GcN1WwLStX4=";
  };
in
bash.runCommand "${pname}-${version}"
  {
    inherit pname version;

    nativeBuildInputs = [
      gcc
      musl
      binutils
      gnumake
      gnused
      gnugrep
      gawk
      gzip
      gnutarBoot
    ];

    passthru.tests.get-version =
      result:
      bash.runCommand "${pname}-get-version-${version}" { } ''
        ${result}/bin/tar --version
        mkdir $out
      '';

    meta = with lib; {
      description = "GNU implementation of the `tar' archiver";
      homepage = "https://www.gnu.org/software/tar";
      license = licenses.gpl3Plus;
      maintainers = teams.minimal-bootstrap.members;
      mainProgram = "tar";
      platforms = platforms.unix;
    };
  }
  ''
    # Unpack
    tar xzf ${src}
    cd tar-${version}

    # Configure
    bash ./configure \
      --prefix=$out \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config} \
      CC=musl-gcc

    # Build
    make -j $NIX_BUILD_CORES

    # Install
    make -j $NIX_BUILD_CORES install
  ''
