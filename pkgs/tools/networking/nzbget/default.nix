{ stdenv, fetchurl, pkgconfig, libxml2, ncurses, libsigcxx, libpar2
, gnutls, libgcrypt, zlib, openssl }:

stdenv.mkDerivation rec {
  name = "nzbget-${version}";
  version = "17.0-r1686";
  filename = "nzbget-17.0-testing-r1686";

  src = fetchurl {
    url = "http://github.com/nzbget/nzbget/releases/download/v${version}/${filename}-src.tar.gz";
    sha256 = "0hk0hiccdk3bivdnc2635kqqdwgwf73wvis1wl9k0snds25dwfiw";
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
