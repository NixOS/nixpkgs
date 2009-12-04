{stdenv, fetchurl, pkgconfig, libuuid}:

stdenv.mkDerivation rec {
  name = "e2fsprogs-1.41.9";

  src = fetchurl {
    url = "mirror://sourceforge/e2fsprogs/${name}.tar.gz";
    sha256 = "1s365fpv5w5m8n6n5fnn6q003whr1clr22xn25wkssx1c51f7wfb";
  };

  buildInputs = [pkgconfig libuuid];

  # libuuid, libblkid, uuidd and fsck are in util-linux-ng (the "libuuid" dependency).
  configureFlags = "--enable-elf-shlibs --disable-libuuid --disable-libblkid --disable-uuidd --disable-fsck";

  preInstall = "installFlagsArray=('LN=ln -s')";
  
  postInstall = "make install-libs";
  
  meta = {
    homepage = http://e2fsprogs.sourceforge.net/;
    description = "Tools for creating and checking ext2/ext3/ext4 filesystems";
  };
}
