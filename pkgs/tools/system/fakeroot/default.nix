{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "fakeroot-1.14.5";

  src = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.14.5.orig.tar.bz2;
    sha256 = "0s5f785qsh057z05l9i5k1h9cbj9x26ki37l4wh4iyabjhschddh";
  };

  meta = {
    homepage = http://fakeroot.alioth.debian.org/;
    description = "Give a fake root environment through LD_PRELOAD";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };

}
