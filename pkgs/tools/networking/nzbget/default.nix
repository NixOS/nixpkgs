{ stdenv, fetchurl, pkgconfig, libxml2, ncurses, libsigcxx, libpar2
, gnutls, libgcrypt }:

stdenv.mkDerivation rec {
  name = "nzbget-14.1";

  src = fetchurl {
    url = "mirror://sourceforge/nzbget/${name}.tar.gz";
    sha256 = "062bvf0r290qi3xgbvvwgxxmnka7raa71dz9fg1mq0zpc5mq2sx1";
  };

  buildInputs = [ pkgconfig libxml2 ncurses libsigcxx libpar2 gnutls libgcrypt ];

  enableParallelBuilding = true;

  NIX_LDFLAGS = "-lz";

  meta = with stdenv.lib; {
    homepage = http://nzbget.sourceforge.net/;
    license = licenses.gpl2Plus;
    description = "A command line tool for downloading files from news servers";
    maintainers = with maintainers; [ pSub ];
  };
}
