{stdenv, fetchurl, x11, libpng, libjpeg, expat, libXaw, yacc}:

assert libpng != null && libjpeg != null && expat != null;

stdenv.mkDerivation {
  name = "graphviz-1.12";

  src = fetchurl {
#    url = http://www.graphviz.org/pub/graphviz/ARCHIVE/graphviz-1.10.tar.gz;
#    md5 = "e1402531abff68d146bf94e72b44dc2a";
    url = http://www.graphviz.org/pub/graphviz/ARCHIVE/graphviz-1.12.tar.gz;
    md5 = "a5c004c42f58c957f772060d0889059c";
  };

  buildInputs = [x11 libpng libjpeg expat libXaw yacc];
  configureFlags = [
    (if x11 == null then "--without-x" else "")
  ];
}
