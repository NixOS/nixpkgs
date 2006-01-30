{stdenv, fetchurl, x11, libpng, libjpeg, expat, libXaw, yacc, libtool}:

assert libpng != null && libjpeg != null && expat != null;

stdenv.mkDerivation {
  name = "graphviz-2.4";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/graphviz-2.4.tar.gz;
    md5 = "f1074d38a7eeb5e5b2ebfdb643aebf8a";
  };

  buildInputs = [x11 libpng libjpeg expat libXaw yacc libtool];
  configureFlags = [
    (if x11 == null then "--without-x" else "")
  ];
  
  inherit libpng libjpeg expat;
}
