{ stdenv, fetchurl, libtorrent, ncurses, pkgconfig, libsigcxx, curl
, zlib, openssl, xmlrpc_c
}:

stdenv.mkDerivation rec {
  name = "rtorrent-0.9.4";

  src = fetchurl {
    url = "http://libtorrent.rakshasa.no/downloads/${name}.tar.gz";
    sha256 = "113yrrac75vqi4g8r6bgs0ggjllj9bkg9shv08vqzdhkwqg2q2mw";
  };

  buildInputs = [ libtorrent ncurses pkgconfig libsigcxx curl zlib openssl xmlrpc_c ];
  configureFlags = "--with-xmlrpc-c";

  # postInstall = ''
  #   mkdir -p $out/share/man/man1 $out/share/rtorrent
  #   mv doc/rtorrent.1 $out/share/man/man1/rtorrent.1
  #   mv doc/rtorrent.rc $out/share/rtorrent/rtorrent.rc
  # '';

  meta = {
    homepage = "http://libtorrent.rakshasa.no/";
    description = "An ncurses client for libtorrent, ideal for use with screen or dtach";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
