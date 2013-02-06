{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "lzip-1.14-rc3";

  src = fetchurl {
    url = "http://download.savannah.gnu.org/releases/lzip/${name}.tar.gz";
    sha256 = "040mmfadvhry68bv10baqi1bs8g5wwbf5rx0widyz69llpn64mw9";
  };

  doCheck = true;

  meta = {
    homepage = "http://www.nongnu.org/lzip/lzip.html";
    description = "a lossless data compressor based on the LZMA algorithm";
    license = stdenv.lib.licenses.gpl3Plus;

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
