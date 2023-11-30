{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, xz
, lzo
, zlib
, zstd
, lz4
, lz4Support ? false
}:

let
  patch = fetchFromGitHub
    {
      # NOTE: This uses my personal fork for now, until
      # https://github.com/devttys0/sasquatch/pull/40 is merged.
      # I, cole-h, will keep this fork available until that happens.
      owner = "cole-h";
      repo = "sasquatch";
      rev = "6edc54705454c6410469a9cb5bc58e412779731a";
      sha256 = "x+PuPYGD4Pd0fcJtlLWByGy/nggsmZkxwSXxJfPvUgo=";
    } + "/patches/patch0.txt";
in
stdenv.mkDerivation rec {
  pname = "sasquatch";
  version = "4.4";

  src = fetchurl {
    url = "mirror://sourceforge/squashfs/squashfs${version}.tar.gz";
    sha256 = "qYGz8/IFS1ouZYhRo8BqJGCtBKmopkXgr+Bjpj/bsH4=";
  };

  buildInputs = [
    xz
    lzo
    zlib
    zstd
  ]
  ++ lib.optionals lz4Support [ lz4 ];

  patches = [ patch ];
  patchFlags = [ "-p0" ];

  postPatch = ''
    # Drop blanket -Werror to avoid build failure on fresh toolchains
    # like gcc-11.
    substituteInPlace squashfs-tools/Makefile --replace ' -Werror' ' '
    cd squashfs-tools
  '';

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: unsquashfs_xattr.o:/build/squashfs4.4/squashfs-tools/error.h:34: multiple definition of
  #     `verbose'; unsquashfs.o:/build/squashfs4.4/squashfs-tools/error.h:34: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  installFlags = [ "INSTALL_DIR=\${out}/bin" ];

  makeFlags = [
    "XZ_SUPPORT=1"
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
    "AR=${stdenv.cc.targetPrefix}ar"
  ]
    ++ lib.optional lz4Support "LZ4_SUPPORT=1";

  meta = with lib; {
    homepage = "https://github.com/devttys0/sasquatch";
    description = "Set of patches to the standard unsquashfs utility (part of squashfs-tools) that attempts to add support for as many hacked-up vendor-specific SquashFS implementations as possible";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.pamplemousse ];
    platforms = platforms.linux;
    mainProgram = "sasquatch";
  };
}
