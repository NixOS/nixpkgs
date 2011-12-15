{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "fakeroot-1.18.1";

  src = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.18.1.orig.tar.bz2;
    sha256 = "0h5jsw715a9hv32cb1m1bajy26l7xxrbgrk6qk1b6m91lxh6rnw9";
  };

  meta = {
    homepage = http://fakeroot.alioth.debian.org/;
    description = "Give a fake root environment through LD_PRELOAD";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };

}
