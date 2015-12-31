{ stdenv, fetchurl, pkgconfig, libxml2, ncurses, libsigcxx, libpar2
, gnutls, libgcrypt, zlib }:

stdenv.mkDerivation rec {
  name = "nzbget-${version}";
  version = "16.4";

  src = fetchurl {
    url = "http://github.com/nzbget/nzbget/releases/download/v${version}/${name}-src.tar.gz";
    sha256 = "03sdzxxsjpxp82jpk593xls96yk29989z05j73jah21dbpkkx7lf";
  };

  buildInputs = [ pkgconfig libxml2 ncurses libsigcxx libpar2 gnutls
                  libgcrypt zlib ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://nzbget.net;
    license = licenses.gpl2Plus;
    description = "A command line tool for downloading files from news servers";
    maintainers = with maintainers; [ pSub ];
  };
}
