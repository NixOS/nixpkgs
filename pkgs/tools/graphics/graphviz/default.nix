{stdenv, fetchurl, x11, libpng, libjpeg, expat, libXaw, yacc, libtool}:

assert libpng != null && libjpeg != null && expat != null;

stdenv.mkDerivation {
  name = "graphviz-2.4";

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/graphviz-2.4.tar.gz;
    md5 = "f1074d38a7eeb5e5b2ebfdb643aebf8a";
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
