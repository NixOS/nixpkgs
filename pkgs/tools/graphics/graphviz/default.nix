{stdenv, fetchurl, x11, libpng, libjpeg, expat, libXaw, yacc}:

assert libpng != null && libjpeg != null && expat != null;

stdenv.mkDerivation {
  name = "graphviz-2.2";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/graphviz-2.2.tar.gz;
    md5 = "9275d30695a5c22f360acbef7b85acd3";
  };

  buildInputs = [x11 libpng libjpeg expat libXaw yacc];
  configureFlags = [
    (if x11 == null then "--without-x" else "")
  ];
  
  inherit libpng libjpeg expat;
}
