{ stdenv, fetchurl, libtorrent, ncurses, pkgconfig, libsigcxx, curl
, zlib, openssl, xmlrpc_c
}:

stdenv.mkDerivation rec {
  name = "rtorrent-${version}";
  version = "0.9.6";

  src = fetchurl {
    url = "http://rtorrent.net/downloads/${name}.tar.gz";
    sha256 = "03jvzw9pi2mhcm913h8qg0qw9gwjqc6lhwynb1yz1y163x7w4s8y";
  };

  buildInputs = [ libtorrent ncurses pkgconfig libsigcxx curl zlib openssl xmlrpc_c ];
  configureFlags = "--with-xmlrpc-c";

  # postInstall = ''
  #   mkdir -p $out/share/man/man1 $out/share/rtorrent
  #   mv doc/rtorrent.1 $out/share/man/man1/rtorrent.1
  #   mv doc/rtorrent.rc $out/share/rtorrent/rtorrent.rc
  # '';

  meta = with stdenv.lib; {
    homepage = https://github.com/rakshasa/rtorrent/;
    description = "An ncurses client for libtorrent, ideal for use with screen, tmux, or dtach";

    platforms = platforms.unix;
    maintainers = with maintainers; [ simons ebzzry ];
  };
}
