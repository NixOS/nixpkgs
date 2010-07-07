{ stdenv, fetchurl, libuuid }:

stdenv.mkDerivation rec {
  name = "reiserfsprogs-3.6.21";

  src = fetchurl {
    url = "http://www.kernel.org/pub/linux/utils/fs/reiserfs/${name}.tar.bz2";
    sha256 = "19mqzhh6jsf2gh8zr5scqi9pyk1fwivrxncd11rqnp2148c58jam";
  };

  buildInputs = [ libuuid ];

  postInstall =
    ''
      ln -s reiserfsck $out/sbin/fsck.reiserfs
      ln -s mkreiserfs $out/sbin/mkfs.reiserfs
    '';

  meta = {
    homepage = http://www.namesys.com/;
    description = "ReiserFS utilities";
    license = "GPL-2";
  };
}
