{ stdenv, fetchurl, pkgconfig, libpng, libjpeg, expat, libXaw
, yacc, libtool, fontconfig, pango, gd, xlibs
}:

stdenv.mkDerivation rec {
  name = "graphviz-2.26.3";

  src = fetchurl {
    url = "http://www.graphviz.org/pub/graphviz/ARCHIVE/${name}.tar.gz";
    sha256 = "18bzyg17ni0lpcd2g5dhan8fjv3vzkjym38jq8vm42did5p9j47l";
  };

  buildInputs =
    [ pkgconfig libpng libjpeg expat libXaw yacc libtool fontconfig
      pango gd
    ] ++ stdenv.lib.optionals (xlibs != null) [ xlibs.xlibs xlibs.libXrender ];
  
  configureFlags =
    [ "--with-pngincludedir=${libpng}/include"
      "--with-pnglibdir=${libpng}/lib"
      "--with-jpegincludedir=${libjpeg}/include"
      "--with-jpeglibdir=${libjpeg}/lib"
      "--with-expatincludedir=${expat}/include"
      "--with-expatlibdir=${expat}/lib"
    ]
    ++ stdenv.lib.optional (xlibs == null) "--without-x";

  meta = {
    description = "A program for visualising graphs";
    homepage = http://www.graphviz.org/;
  };
}
