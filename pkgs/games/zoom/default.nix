{stdenv, fetchurl, perl, expat, x11, freetype}:

# !!! assert freetype == xlibs.freetype

stdenv.mkDerivation {
  name = "zoom-1.1.5";
  
  src = fetchurl {
    url = http://www.logicalshift.co.uk/unix/zoom/zoom-1.1.5.tar.gz;
    sha256 = "1g6van7f7sg3zfcz80mncnnbccyg2hnm0hq4x558vpsm0lf7z5pj";
  };
  
  buildInputs = [perl expat x11 freetype];
  
  # Zoom doesn't add the right directory in the include path.
  CFLAGS = ["-I" (freetype + "/include/freetype2")];
}
