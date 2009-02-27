{ stdenv, fetchurl, pkgconfig, x11, libpng, libjpeg, expat, libXaw
, yacc, libtool, fontconfig, pango, gd
}:

assert libpng != null && libjpeg != null && expat != null;

stdenv.mkDerivation rec {
  name = "graphviz-2.20.3";

  src = fetchurl {
    url = "http://www.graphviz.org/pub/graphviz/ARCHIVE/${name}.tar.gz";
    sha256 = "0grrijj3ryacnc0qj8l6xp5nqnmff5nvx6ziij1r9lghzb17cdjq";
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
