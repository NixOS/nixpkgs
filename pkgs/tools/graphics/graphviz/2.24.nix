{ stdenv, fetchurl, pkgconfig, x11, libpng, libjpeg, expat, libXaw
, yacc, libtool, fontconfig, pango, gd
}:

assert libpng != null && libjpeg != null && expat != null;

stdenv.mkDerivation rec {
  name = "graphviz-2.24.0";

  src = fetchurl {
    url = "http://www.graphviz.org/pub/graphviz/ARCHIVE/${name}.tar.gz";
    sha256 = "01182be7851ef6d292a916b19ac25a33bce5dccbd4661bf3101abbd3dfb1ae00";
  };

  buildInputs = [pkgconfig x11 libpng libjpeg expat libXaw yacc libtool fontconfig pango gd];
  
  configureFlags =
    [ "--with-pngincludedir=${libpng}/include"
      "--with-pnglibdir=${libpng}/lib"
      "--with-jpegincludedir=${libjpeg}/include"
      "--with-jpeglibdir=${libjpeg}/lib"
      "--with-expatincludedir=${expat}/include"
      "--with-expatlibdir=${expat}/lib"
      "--with-codegens"
    ]
    ++ stdenv.lib.optional (x11 == null) "--without-x";

  meta = {
    description = "A program for visualising graphs";
    homepage = http://www.graphviz.org/;
  };
}
