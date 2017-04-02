{ stdenv, fetchurl, pkgconfig, libxml2, ncurses, libsigcxx, libpar2
, gnutls, libgcrypt, zlib, openssl }:

stdenv.mkDerivation rec {
  name = "nzbget-${version}";
  version = "18.0";

  src = fetchurl {
    url = "http://github.com/nzbget/nzbget/releases/download/v${version}/nzbget-${version}-src.tar.gz";
    sha256 = "0nzm2qbhwrbq02ynfl2vgs6k58bk5fk45d3547a4g1lqhri3dijb";
  };

  buildInputs = [ pkgconfig libxml2 ncurses libsigcxx libpar2 gnutls
                  libgcrypt zlib openssl ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://nzbget.net;
    license = licenses.gpl2Plus;
    description = "A command line tool for downloading files from news servers";
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
  };
}
