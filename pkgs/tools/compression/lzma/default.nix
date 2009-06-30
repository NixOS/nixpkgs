{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "lzma-4.32.7";
  
  src = fetchurl {
    url = mirror://gentoo/distfiles/lzma-4.32.7.tar.gz;
    sha256 = "0b03bdvm388kwlcz97aflpr3ir1zpa3m0bq3s6cd3pp5a667lcwz";
  };

  CFLAGS = "-O3";
  CXXFLAGS = "-O3";

  meta = {
    homepage = http://tukaani.org/lzma/;
    description = "The LZMA compression program";
  };
}
