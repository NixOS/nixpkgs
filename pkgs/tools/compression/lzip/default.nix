{ stdenv, fetchurl, texinfo }:

stdenv.mkDerivation rec {
  name = "lzip-1.14";

  buildInputs = [ texinfo ];

  src = fetchurl {
    url = "http://download.savannah.gnu.org/releases/lzip/${name}.tar.gz";
    sha256 = "1rybhk2pxpfh2789ck9mrkdv3bpx7b7miwndlshb5vb02m9crxbz";
  };

  doCheck = true;

  meta = {
    homepage = "http://www.nongnu.org/lzip/lzip.html";
    description = "a lossless data compressor based on the LZMA algorithm";
    license = stdenv.lib.licenses.gpl3Plus;

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
