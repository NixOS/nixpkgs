{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  gcc,
  binutils,
  binutils-build,
  linux-headers,
  gnumake,
  gnused,
  gnugrep,
  gawk,
  diffutils,
  findutils,
  python,
  bison,
  gnutar,
  xz,
}:
let
  pname = "glibc-headers";
  version = "2.42";

  src = fetchurl {
    url = "mirror://gnu/libc/glibc-${version}.tar.xz";
    hash = "sha256-0XdeMuRijmTvkw9DW2e7Y691may2viszW58Z8WUJ8X8=";
  };
in
bash.runCommand "${pname}-${version}"
  {
    inherit pname version;

    nativeBuildInputs = [
      gcc
      binutils
      binutils-build
      gnumake
      gnused
      gnugrep
      gawk
      diffutils
      findutils
      python
      bison
      gnutar
      xz
    ];

    meta = {
      description = "The GNU C Library";
      homepage = "https://www.gnu.org/software/libc/";
      license = lib.licenses.lgpl2Plus;
      platforms = lib.platforms.linux;
      teams = [ lib.teams.minimal-bootstrap ];
    };
  }
  ''
    # Unpack
    tar xf ${src}
    cd glibc-${version}

    # Configure
    mkdir build
    cd build
    # libstdc++.so is built against musl and fails to link
    export CXX=false
    bash ../configure \
      --prefix=$out \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config} \
      --with-headers=${linux-headers}/include \
      --disable-dependency-tracking

    # Install
    make -j $NIX_BUILD_CORES INSTALL_UNCOMPRESSED=yes install-headers install-bootstrap-headers=yes
    ln -s $(ls -d ${linux-headers}/include/* | grep -v scsi\$) $out/include/

    # https://sources.debian.org/patches/glibc/2.43-1/any/local-bootstrap-headers.diff/
    touch $out/include/gnu/stubs.h
  ''
