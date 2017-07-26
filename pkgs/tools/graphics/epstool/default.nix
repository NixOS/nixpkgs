{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "3.08";
  name = "epstool-${version}";

  src = fetchurl {
    url = "http://ftp.de.debian.org/debian/pool/main/e/epstool/epstool_${version}+repack.orig.tar.gz";
    sha256 = "1pfgqbipwk36clhma2k365jkpvyy75ahswn8jczzys382jalpwgk";
  };

  installPhase = ''
    make EPSTOOL_ROOT=$out install
  '';

  patches = [ ./gcc43.patch ];

  meta = with stdenv.lib; {
    description = "A utility to create or extract preview images in EPS files, fix bounding boxes and convert to bitmaps";
    homepage = http://pages.cs.wisc.edu/~ghost/gsview/epstool.htm;
    license = licenses.gpl2;
    maintainers = [ maintainers.asppsa ];
    platforms = platforms.linux;
  };
}
