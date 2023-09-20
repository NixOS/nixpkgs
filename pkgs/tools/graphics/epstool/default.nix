{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "3.09";
  pname = "epstool";

  src = fetchurl {
    url = "http://ftp.de.debian.org/debian/pool/main/e/epstool/epstool_${version}.orig.tar.xz";
    hash = "sha256-HoUknRpE+UGLH5Wjrr2LB4TauOSd62QXrJuZbKCPYBE=";
  };

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "CLINK=${stdenv.cc.targetPrefix}cc"
    "LINK=${stdenv.cc.targetPrefix}cc"
  ];

  installPhase = ''
    make EPSTOOL_ROOT=$out install
  '';

  meta = with lib; {
    description = "A utility to create or extract preview images in EPS files, fix bounding boxes and convert to bitmaps";
    homepage = "http://pages.cs.wisc.edu/~ghost/gsview/epstool.htm";
    license = licenses.gpl2;
    maintainers = [ maintainers.asppsa ];
    platforms = platforms.all;
  };
}
