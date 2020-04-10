{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "ncompress-4.2.4.5";

  builder = ./builder.sh;

  patches = [ ./makefile.patch ];

  src = fetchurl {
    url = "mirror://sourceforge/project/ncompress/${name}.tar.gz";
    sha256 = "0fwhfijnzggqpbmln82zq7zp6sra7p9arfakswicwi7qsp6vnxgm";
  };

  meta = {
    homepage = "http://ncompress.sourceforge.net/";
    license = stdenv.lib.licenses.publicDomain;
    description = "A fast, simple LZW file compressor";
    platforms = stdenv.lib.platforms.unix;
  };
}
