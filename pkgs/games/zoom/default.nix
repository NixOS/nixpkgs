{stdenv, fetchurl, perl, expat, x11, freetype}:

# !!! assert freetype == xlibs.freetype

stdenv.mkDerivation {
  name = "zoom-1.0.2alpha1";
  
  src = fetchurl {
    url = http://www.logicalshift.demon.co.uk/unix/zoom/zoom-1.0.2alpha1.tar.gz;
    md5 = "91b2fe444028178aa3b23bd0e3ae1a61";
  };
  
  buildInputs = [perl expat x11 freetype];
  
  # Zoom doesn't add the right directory in the include path.
  CFLAGS = ["-I" (freetype + "/include/freetype2")];
}
