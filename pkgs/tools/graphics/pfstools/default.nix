{stdenv, fetchurl, libtiff, openexr, imagemagick, libjpeg, qt, mesa,
freeglut, bzip2, libX11, libpng, expat }:

stdenv.mkDerivation {
  name = "pfstools-1.8.0";

  src = fetchurl {
    url = mirror://sourceforge/pfstools/pfstools-1.8.0.tar.gz;
    sha256 = "19gncsfhypiaarsyhmca52yjx8cv86n31b6hxmdac8z4pczhg3gv";
  };

  buildInputs = [ libtiff openexr imagemagick libjpeg qt mesa freeglut
    bzip2 libX11 libpng expat ];

  meta = {
    homepage = http://pfstools.sourceforge.net/;
    description = "Toolkit for manipulation of HDR images";
    license = "GPL";
  };
}
