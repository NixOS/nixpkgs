{ stdenv, fetchurl, pkgconfig, libxml2, ncurses, libsigcxx, libpar2
, gnutls, libgcrypt }:

stdenv.mkDerivation rec {
  name = "nzbget-14.0";

  src = fetchurl {
    url = "mirror://sourceforge/nzbget/${name}.tar.gz";
    sha256 = "1r9qdp17px8vq3mh18fzxhm5cqd37wcz2vv7hsxdq8rmgxhl7lj1";
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
