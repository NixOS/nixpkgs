{stdenv, fetchurl, perl, expat, xlibs, freetype}:

# !!! assert freetype == xlibs.freetype

stdenv.mkDerivation {
  name = "zoom-1.0.2alpha1";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/zoom-1.0.2alpha1.tar.gz;
    md5 = "91b2fe444028178aa3b23bd0e3ae1a61";
  };
  buildInputs = [perl expat xlibs freetype];
  # Zoom doesn't add the right directory in the include path.
  CFLAGS = ["-I" (freetype ~ /include/freetype2)];
}
