{stdenv, fetchurl, x11, libpng, libjpeg, expat, libXaw, yacc, libtool}:

assert libpng != null && libjpeg != null && expat != null;

stdenv.mkDerivation {
  name = "graphviz-2.12";

  src = fetchurl {
    url = http://www.graphviz.org/pub/graphviz/ARCHIVE/graphviz-2.12.tar.gz;
    md5 = "e5547bc0ec47943c72f5c3e2b5dff58f";
  };

  buildInputs = [x11 libpng libjpeg expat libXaw yacc libtool];
  configureFlags =
    [ "--with-pngincludedir=${libpng}/include"
      "--with-pnglibdir=${libpng}/lib"
      "--with-jpegincludedir=${libjpeg}/include"
      "--with-jpeglibdir=${libjpeg}/lib"
      "--with-expatincludedir=${expat}/include"
      "--with-expatlibdir=${expat}/lib"
    ]
    ++ (if x11 == null then ["--without-x"] else []);
}
