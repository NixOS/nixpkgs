{ stdenv, fetchurl, pkgconfig, xlibsWrapper, libpng, libjpeg, expat, libXaw
, yacc, libtool, fontconfig, pango, gd
}:

assert libpng != null && libjpeg != null && expat != null;

stdenv.mkDerivation rec {
  name = "graphviz-2.0";

  src = fetchurl {
    url = "http://www.graphviz.org/pub/graphviz/ARCHIVE/${name}.tar.gz";
    sha256 = "39b8e1f2ba4cc1f5bdc8e39c7be35e5f831253008e4ee2c176984f080416676c";
  };

  buildInputs = [pkgconfig xlibsWrapper libpng libjpeg expat libXaw yacc libtool fontconfig pango gd];
  
  configureFlags =
    [ "--with-pngincludedir=${libpng}/include"
      "--with-pnglibdir=${libpng.out}/lib"
      "--with-jpegincludedir=${libjpeg}/include"
      "--with-jpeglibdir=${libjpeg.out}/lib"
      "--with-expatincludedir=${expat}/include"
      "--with-expatlibdir=${expat.out}/lib"
    ]
    ++ stdenv.lib.optional (xlibsWrapper == null) "--without-x";

  meta = {
    description = "A program for visualising graphs";
    homepage = http://www.graphviz.org/;
    branch = "2.0";
  };
}
