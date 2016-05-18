{ stdenv, fetchurl, texinfo }:

stdenv.mkDerivation rec {
  name = "lzip-1.17";

  buildInputs = [ texinfo ];

  src = fetchurl {
    url = "mirror://savannah/lzip/${name}.tar.gz";
    sha256 = "0lh3x964jjldx3piax6c2qzlhfiir5i6rnrcn8ri44rk19g8ahwl";
  };

  configureFlags = "CPPFLAGS=-DNDEBUG CFLAGS=-O3 CXXFLAGS=-O3";

  doCheck = true;

  meta = {
    homepage = "http://www.nongnu.org/lzip/lzip.html";
    description = "a lossless data compressor based on the LZMA algorithm";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
