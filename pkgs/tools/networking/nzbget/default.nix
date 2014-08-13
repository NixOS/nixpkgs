{ stdenv, fetchurl, pkgconfig, libxml2, ncurses, libsigcxx, libpar2
, gnutls, libgcrypt }:

stdenv.mkDerivation rec {
  name = "nzbget-13.0";

  src = fetchurl {
    url = "mirror://sourceforge/nzbget/${name}.tar.gz";
    sha256 = "13lgwwrdv6ds25kj6hj0b5laqaf739n7l3j530x3640zyd254vv6";
  };

  buildInputs = [ pkgconfig libxml2 ncurses libsigcxx libpar2 gnutls libgcrypt ];

  enableParallelBuilding = true;

  NIX_LDFLAGS = "-lz";

  meta = {
    homepage = http://nzbget.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    description = "A command line tool for downloading files from news servers";
  };
}
