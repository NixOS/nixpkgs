{ stdenv, fetchurl, libXaw, freetype }:
stdenv.mkDerivation rec {
  name = "libotf-0.9.16";

  src = fetchurl {
    url = "http://download.savannah.gnu.org/releases/m17n/${name}.tar.gz";
    sha256 = "0sq6g3xaxw388akws6qrllp3kp2sxgk2dv4j79k6mm52rnihrnv8";
  };

  buildInputs = [ libXaw freetype ];

  meta = {
    homepage = http://www.nongnu.org/m17n/;
    description = "Multilingual text processing library (libotf)";
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ bendlas ];
  };
}
