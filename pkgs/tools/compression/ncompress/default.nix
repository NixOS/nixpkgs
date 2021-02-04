{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "ncompress-4.2.4.6";

  builder = ./builder.sh;

  patches = [ ./makefile.patch ];

  src = fetchurl {
    url = "mirror://sourceforge/project/ncompress/${name}.tar.gz";
    sha256 = "0sw3c7h80v9pagfqfx16ws9w2y3yrajrdk54bgiwdm0b0q06lyzv";
  };

  meta = {
    homepage = "http://ncompress.sourceforge.net/";
    license = lib.licenses.publicDomain;
    description = "A fast, simple LZW file compressor";
    platforms = lib.platforms.unix;
  };
}
