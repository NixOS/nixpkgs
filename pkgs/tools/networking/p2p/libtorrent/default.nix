{ stdenv, fetchurl, pkgconfig, openssl, libsigcxx }:

let
  version = "0.12.9";
in
stdenv.mkDerivation {
  name = "libtorrent-${version}";

  src = fetchurl {
    url = "http://libtorrent.rakshasa.no/downloads/libtorrent-${version}.tar.gz";
    sha256 = "0r5gjh2kc6fdimh5xxg7qsx2390cxw4fz6srgr20y1sxsj6rxp0m";
  };

  buildInputs = [ pkgconfig openssl libsigcxx ];

  meta = {
    homepage = "http://libtorrent.rakshasa.no/";
    description = "A BitTorrent library written in C++ for *nix, with a focus on high performance and good code";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
