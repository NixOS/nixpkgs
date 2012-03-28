{ stdenv, fetchurl, pkgconfig, libpng, libjpeg, expat, libXaw
, yacc, libtool, fontconfig, pango, gd, xlibs
}:

stdenv.mkDerivation rec {
  name = "graphviz-2.28.0";

  src = fetchurl {
    url = "http://www.graphviz.org/pub/graphviz/ARCHIVE/${name}.tar.gz";
    sha256 = "0xpwg99cd8sp0c6r8klsmc66h1pday64kmnr4v6f9jkqqmrpkank";
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

  preBuild = ''
    sed -e 's@am__append_5 *=.*@am_append_5 =@' -i lib/gvc/Makefile
  '';

  postInstall = ''
    sed -i 's|`which lefty`|"'$out'/bin/lefty"|' $out/bin/dotty
  '';

  meta = {
    description = "A program for visualising graphs";
    homepage = http://www.graphviz.org/;
  };
}
