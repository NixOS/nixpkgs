{
  lib,
  fetchurl,
  bash,
  gcc,
  musl,
  binutils,
  gnumake,
  gnused,
  gnugrep,
  gawk,
  diffutils,
  findutils,
  gnutar,
  xz,
}:
let
  pname = "linux-headers";
  version = "6.5.6";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v${lib.versions.major version}.x/linux-${version}.tar.xz";
    hash = "sha256-eONtQhRUcFHCTfIUD0zglCjWxRWtmnGziyjoCUqV0vY=";
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
      diffutils
      findutils
      gnutar
      xz
    ];

    meta = {
      description = "Header files and scripts for Linux kernel";
      license = lib.licenses.gpl2Only;
      platforms = lib.platforms.linux;
      teams = [ lib.teams.minimal-bootstrap ];
    };
  }
  ''
    # Unpack
    tar xf ${src}
    cd linux-${version}

    # Build
    make -j $NIX_BUILD_CORES CC=musl-gcc HOSTCC=musl-gcc ARCH=x86 headers

    # Install
    find usr/include -name '.*' -exec rm {} +
    mkdir -p $out
    cp -rv usr/include $out/
  ''
