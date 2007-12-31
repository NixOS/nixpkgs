{stdenv, fetchurl, x11, libpng, libjpeg, expat, libXaw, yacc, libtool}:

assert libpng != null && libjpeg != null && expat != null;

stdenv.mkDerivation {
  name = "graphviz-2.16.1";

  src = fetchurl {
    url = http://www.graphviz.org/pub/graphviz/ARCHIVE/graphviz-2.16.1.tar.gz;
    sha256 = "1lan1hyar0xbqvnkcmlcvv02g8zfpk94gk04y4sik5irpa2s3h9j";
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
    ++ stdenv.lib.optional (x11 == null) "--without-x";

  meta = {
    description = "A program for visualising graphs";
    homepage = http://www.graphviz.org/;
  };
}
