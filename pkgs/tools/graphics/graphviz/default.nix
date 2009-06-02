{ stdenv, fetchurl, pkgconfig, x11, libpng, libjpeg, expat, libXaw
, yacc, libtool, fontconfig, pango, gd
}:

assert libpng != null && libjpeg != null && expat != null;

stdenv.mkDerivation rec {
  name = "graphviz-2.22.2";

  src = fetchurl {
    url = "http://www.graphviz.org/pub/graphviz/ARCHIVE/${name}.tar.gz";
    sha256 = "1yzda1al32la3wyrxwc1hs83sx9p84zh6xlpcpkx90xvjaav827v";
  };

  buildInputs = [pkgconfig x11 libpng libjpeg expat libXaw yacc libtool fontconfig pango gd];
  
  configureFlags =
    [ "--with-pngincludedir=${libpng}/include"
      "--with-pnglibdir=${libpng}/lib"
      "--with-jpegincludedir=${libjpeg}/include"
      "--with-jpeglibdir=${libjpeg}/lib"
      "--with-expatincludedir=${expat}/include"
      "--with-expatlibdir=${expat}/lib"
    ]
    ++ stdenv.lib.optional (x11 == null) "--without-x";

  meta = {
    description = "A program for visualising graphs";
    homepage = http://www.graphviz.org/;
  };
}
