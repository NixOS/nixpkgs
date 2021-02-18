{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "ncompress-5.0";

  builder = ./builder.sh;

  patches = [ ./makefile.patch ];

  src = fetchurl {
    url = "mirror://sourceforge/project/ncompress/${name}.tar.gz";
    sha256 = "004r086c11sw9vg2j3srgxpz98w8pycjl33bk3pgqnd0s92igrn4";
  };

  meta = {
    homepage = "http://ncompress.sourceforge.net/";
    license = lib.licenses.publicDomain;
    description = "A fast, simple LZW file compressor";
    platforms = lib.platforms.unix;
  };
}
