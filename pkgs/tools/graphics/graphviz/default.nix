{stdenv, fetchurl, x11, libpng, libjpeg, expat, libXaw}:

assert libpng != null && libjpeg != null && expat != null;

stdenv.mkDerivation {
  name = "graphviz-1.10";

  src = fetchurl {
    url = http://www.graphviz.org/pub/graphviz/ARCHIVE/graphviz-1.10.tar.gz;
    md5 = "e1402531abff68d146bf94e72b44dc2a";
#    url = http://www.graphviz.org/pub/graphviz/ARCHIVE/graphviz-1.12.tar.gz;
#    md5 = "84910caae072c714d107ca9f3e54ace0";
  };

  buildInputs = [x11 libpng libjpeg expat libXaw];
  configureFlags = [
    (if x11 == null then "--without-x" else "")
  ];
}
