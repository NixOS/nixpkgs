{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "ncompress-4.2.4.4";

  builder = ./builder.sh;

  patches = [ ./makefile.patch ];

  src = fetchurl {
    url = "mirror://sourceforge/project/ncompress/${name}.tar.gz";
    sha256 = "0yjiwv1hwb253x3m6r1dq2k7m5c9nz0ib2j7fnm3hark7y6s42xh";
  };

  meta = {
    homepage = http://ncompress.sourceforge.net/;
    license = stdenv.lib.licenses.publicDomain;
    description = "A fast, simple LZW file compressor";
    platforms = stdenv.lib.platforms.unix;
  };
}
