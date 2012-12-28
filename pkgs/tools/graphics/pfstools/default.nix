{stdenv, fetchurl, libtiff, openexr, imagemagick, libjpeg, qt4, mesa,
freeglut, bzip2, libX11, libpng, expat, pkgconfig }:

stdenv.mkDerivation rec {
  name = "pfstools-1.8.3";

  src = fetchurl {
    url = "mirror://sourceforge/pfstools/${name}.tar.gz";
    sha256 = "1j3pzwpxvsx9220176bfjallc73jyda61xqkvnmlxqfd3n7ycgx1";
  };

  configureFlags = "--with-moc=${qt4}/bin/moc";

  buildInputs = [ libtiff openexr imagemagick libjpeg qt4 mesa freeglut
    bzip2 libX11 libpng expat ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    homepage = http://pfstools.sourceforge.net/;
    description = "Toolkit for manipulation of HDR images";
    license = "GPL";
  };
}
