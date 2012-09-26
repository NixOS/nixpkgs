{ stdenv, fetchurl, pkgconfig, libuuid }:

stdenv.mkDerivation rec {
  name = "e2fsprogs-1.42.5";

  src = fetchurl {
    url = "mirror://sourceforge/e2fsprogs/${name}.tar.gz";
    sha256 = "1kki3367961377wz2n6kva8q0wjjk6qhxmhp2dp3ar3lxgcamvbn";
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
