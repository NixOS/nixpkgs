{stdenv, fetchurl, utillinux}:

stdenv.mkDerivation rec {
  name = "fakeroot-1.18.4";

  src = fetchurl {
    url = https://launchpad.net/ubuntu/+archive/primary/+files/fakeroot_1.18.4.orig.tar.bz2;
    sha256 = "18mydrz49n7ic7147pikkpdb96x00s9wisdk6hrc75ll7vx9wd8a";
  };

  buildInputs = [ utillinux /* provides getopt */ ];

  postUnpack = ''
    for prog in getopt; do
      sed -i "s@getopt@$(type -p getopt)@g" ${name}/scripts/fakeroot.in
    done
  '';

  meta = {
    homepage = http://fakeroot.alioth.debian.org/;
    description = "Give a fake root environment through LD_PRELOAD";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };

}
