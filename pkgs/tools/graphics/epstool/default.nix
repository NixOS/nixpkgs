{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
<<<<<<< HEAD
  version = "3.09";
  pname = "epstool";

  src = fetchurl {
    url = "http://ftp.de.debian.org/debian/pool/main/e/epstool/epstool_${version}.orig.tar.xz";
    hash = "sha256-HoUknRpE+UGLH5Wjrr2LB4TauOSd62QXrJuZbKCPYBE=";
=======
  version = "3.08";
  pname = "epstool";

  src = fetchurl {
    url = "http://ftp.de.debian.org/debian/pool/main/e/epstool/epstool_${version}+repack.orig.tar.gz";
    sha256 = "1pfgqbipwk36clhma2k365jkpvyy75ahswn8jczzys382jalpwgk";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "CLINK=${stdenv.cc.targetPrefix}cc"
    "LINK=${stdenv.cc.targetPrefix}cc"
  ];

  installPhase = ''
    make EPSTOOL_ROOT=$out install
  '';

<<<<<<< HEAD
=======
  patches = [ ./gcc43.patch ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A utility to create or extract preview images in EPS files, fix bounding boxes and convert to bitmaps";
    homepage = "http://pages.cs.wisc.edu/~ghost/gsview/epstool.htm";
    license = licenses.gpl2;
    maintainers = [ maintainers.asppsa ];
    platforms = platforms.all;
  };
}
