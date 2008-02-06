{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "lzma-4.32.5";
  
  src = fetchurl {
    url = http://tukaani.org/lzma/lzma-4.32.5.tar.gz;
    sha256 = "1mqy1biy46gqky6n3gyr2l395hwckh0xyi96waz5p5x8mgp372ch";
  };

  CFLAGS = "-O3";
  CXXFLAGS = "-O3";

  meta = {
    homepage = http://tukaani.org/lzma/;
    description = "The LZMA compression program";
  };
}
