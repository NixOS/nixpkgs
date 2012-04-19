{ stdenv, fetchurl, pkgconfig, libuuid }:

stdenv.mkDerivation rec {
  name = "e2fsprogs-1.42.2";

  src = fetchurl {
    url = "mirror://sourceforge/e2fsprogs/${name}.tar.gz";
    sha256 = "1gmq3h4hp4hz1zh8yznx9nb0p7yaykb52f7zkpsqbhjawg2zwdhx";
  };

  buildInputs = [ pkgconfig libuuid ];

  crossAttrs = {
    preConfigure = ''
      export CC=$crossConfig-gcc
    '';
  };

  # libuuid, libblkid, uuidd and fsck are in util-linux-ng (the "libuuid" dependency).
  configureFlags = "--enable-elf-shlibs --disable-libuuid --disable-libblkid --disable-uuidd --disable-fsck";

  preInstall = "installFlagsArray=('LN=ln -s')";
  
  postInstall = "make install-libs";
  
  meta = {
    homepage = http://e2fsprogs.sourceforge.net/;
    description = "Tools for creating and checking ext2/ext3/ext4 filesystems";
  };
}
