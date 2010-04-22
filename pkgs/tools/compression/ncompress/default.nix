{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "ncompress-4.2.4.3";

  builder = ./builder.sh;

  patches = [ ./makefile.patch ];

  src = fetchurl {
    url = "mirror://sourceforge/project/ncompress/${name}.tar.gz";
    sha256 = "1y44ixc1w2vfvj1lm4dkcljlwv882ynrvm5i6l0lg1gf883j246l";
  };

  meta = {
    homepage = http://ncompress.sourceforge.net/;
    license = "public domain";
    description = "A fast, simple LZW file compressor";
  };
}
