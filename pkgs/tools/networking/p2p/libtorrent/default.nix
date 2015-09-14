{ stdenv, fetchurl, pkgconfig, openssl, libsigcxx, zlib }:

stdenv.mkDerivation rec {
  name = "libtorrent-${version}";
  version = "0.13.6";

  src = fetchurl {
    url = "http://rtorrent.net/downloads/${name}.tar.gz";
    sha256 = "012s1nwcvz5m5r4d2z9klgy2n34kpgn9kgwgzxm97zgdjs6a0f18";
  };

  buildInputs = [ pkgconfig openssl libsigcxx zlib ];

  meta = with stdenv.lib; {
    homepage = https://github.com/rakshasa/libtorrent/;
    description = "A BitTorrent library written in C++ for *nix, with focus on high performance and good code";

    platforms = platforms.unix;
    maintainers = with maintainers; [ simons ebzzry ];
  };
}
