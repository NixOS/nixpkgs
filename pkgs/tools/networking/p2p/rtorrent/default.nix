{ stdenv, fetchurl, libtorrent, ncurses, pkgconfig, libsigcxx, curl
, zlib, openssl }:

let
  version = "0.8.9";
in
stdenv.mkDerivation {
  name = "rtorrent-${version}";

  src = fetchurl {
    url = "http://libtorrent.rakshasa.no/downloads/rtorrent-${version}.tar.gz";
    sha256 = "cca70eb36a0c176bbd6fdb3afe2bc9f163fa4c9377fc33bc29689dec60cf6d84";
  };

  buildInputs = [ libtorrent ncurses pkgconfig libsigcxx curl zlib openssl ];

  postInstall = ''
    ensureDir $out/share/man/man1
    mv doc/rtorrent.1 $out/share/man/man1/rtorrent.1
  '';

  meta = {
    homepage = "http://libtorrent.rakshasa.no/";
    description = "An ncurses client for libtorrent, ideal for use with screen or dtach";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
