# NOTE: this is rakshava's version of libtorrent, used mainly by rtorrent
# This is NOT libtorrent-rasterbar, used by Deluge, qbitttorent, and others
{ stdenv, fetchFromGitHub, pkgconfig
, libtool, autoconf, automake, cppunit
, openssl, libsigcxx, zlib }:

stdenv.mkDerivation rec {
  name = "libtorrent-${version}";
  version = "20161212";

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "libtorrent";
    rev = "c167c5a9e0bcf0df23ae5efd91396aae0e37eb87";
    sha256 = "0y9759sxx5dyamyw8w58dsxq7bmnn57q7s2f4cw2zln2pp5gripw";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libtool autoconf automake cppunit openssl libsigcxx zlib ];

  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    homepage = "http://rtorrent.net/downloads/";
    description = "A BitTorrent library written in C++ for *nix, with focus on high performance and good code";

    platforms = platforms.unix;
    maintainers = with maintainers; [ ebzzry codyopel ];
  };
}
