{ stdenv, fetchurl, libtorrent, ncurses, pkgconfig, libsigcxx, curl
, zlib, openssl }:

let
  version = "0.9.2";
in
stdenv.mkDerivation {
  name = "rtorrent-${version}";

  src = fetchurl {
    url = "http://libtorrent.rakshasa.no/downloads/rtorrent-${version}.tar.gz";
    sha256 = "5c8f8c780bee376afce3c1cde2f5ecb928f40bac23b2b8171deed5cf3c888c3d";
  };

  buildInputs = [ libtorrent ncurses pkgconfig libsigcxx curl zlib openssl ];

  postInstall = ''
    mkdir -p $out/share/man/man1 $out/share/rtorrent
    mv doc/rtorrent.1 $out/share/man/man1/rtorrent.1
    mv doc/rtorrent.rc $out/share/rtorrent/rtorrent.rc
  '';

  meta = {
    homepage = "http://libtorrent.rakshasa.no/";
    description = "An ncurses client for libtorrent, ideal for use with screen or dtach";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
