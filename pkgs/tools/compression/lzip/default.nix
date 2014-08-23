{ stdenv, fetchurl, texinfo }:

stdenv.mkDerivation rec {
  name = "lzip-1.15";

  buildInputs = [ texinfo ];

  src = fetchurl {
    url = "mirror://savannah/lzip/${name}.tar.gz";
    sha256 = "1dh5vmj5apizfawnsm50y7z064yx7cz3313przph16gwd3dgrlvw";
  };

  configureFlags = "CPPFLAGS=-DNDEBUG CFLAGS=-O3 CXXFLAGS=-O3";

  doCheck = true;

  meta = {
    homepage = "http://www.nongnu.org/lzip/lzip.html";
    description = "a lossless data compressor based on the LZMA algorithm";
    license = stdenv.lib.licenses.gpl3Plus;

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
