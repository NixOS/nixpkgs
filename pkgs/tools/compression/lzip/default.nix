{ stdenv, fetchurl, texinfo }:

stdenv.mkDerivation rec {
  name = "lzip-1.16";

  buildInputs = [ texinfo ];

  src = fetchurl {
    url = "mirror://savannah/lzip/${name}.tar.gz";
    sha256 = "0l9724rw1l3hg2ldr3n7ihqich4m9nc6y7l302bvdj4jmxdw530j";
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
