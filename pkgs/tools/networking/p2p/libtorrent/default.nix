# NOTE: this is rakshava's version of libtorrent, used mainly by rtorrent
# This is NOT libtorrent-rasterbar, used by Deluge, qbitttorent, and others
{ stdenv, fetchFromGitHub, pkgconfig
, libtool, autoconf, automake, cppunit
, openssl, libsigcxx, zlib }:

stdenv.mkDerivation rec {
  name = "libtorrent-${version}";
  version = "0.13.7";

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "libtorrent";
    rev = "v${version}";
    sha256 = "027qanwcisxhx0bq8dn8cpg8563q0k2pm8ls278f04n7jqvvwkp0";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libtool autoconf automake cppunit openssl libsigcxx zlib ];

  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "A BitTorrent library written in C++ for *nix, with focus on high performance and good code";

    platforms = platforms.unix;
    maintainers = with maintainers; [ ebzzry codyopel ];
  };
}
