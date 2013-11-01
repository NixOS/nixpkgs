{ stdenv, fetchurl, pkgconfig, libuuid }:

stdenv.mkDerivation rec {
  name = "e2fsprogs-1.42.8";

  src = fetchurl {
    url = "mirror://sourceforge/e2fsprogs/${name}.tar.gz";
    sha256 = "b984aaf1fe888d6a4cf8c2e8d397207879599b5368f1d33232c1ec9d68d00c97";
  };

  buildInputs = [ pkgconfig libuuid ];

  crossAttrs = {
    preConfigure = ''
      export CC=$crossConfig-gcc
    '';
  };

  # libuuid, libblkid, uuidd and fsck are in util-linux-ng (the "libuuid" dependency).
  configureFlags = "--enable-elf-shlibs --disable-libuuid --disable-libblkid --disable-uuidd --disable-fsck";

  enableParallelBuilding = true;

  preInstall = "installFlagsArray=('LN=ln -s')";

  postInstall = "make install-libs";

  dontGzipMan = true; # See issue #523

  meta = {
    homepage = http://e2fsprogs.sourceforge.net/;
    description = "Tools for creating and checking ext2/ext3/ext4 filesystems";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
