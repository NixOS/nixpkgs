{ stdenv, fetchurl, texinfo }:

stdenv.mkDerivation rec {
  name = "lzip-${version}";
  version = "1.18";

  buildInputs = [ texinfo ];

  src = fetchurl {
    url = "mirror://savannah/lzip/${name}.tar.gz";
    sha256 = "1p8lvc22sv3damld9ng8y6i8z2dvvpsbi9v7yhr5bc2a20m8iya7";
  };

  configureFlags = "CPPFLAGS=-DNDEBUG CFLAGS=-O3 CXXFLAGS=-O3";

  doCheck = true;

  meta = {
    homepage = "http://www.nongnu.org/lzip/lzip.html";
    description = "A lossless data compressor based on the LZMA algorithm";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
