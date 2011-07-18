{ stdenv, fetchurl, pkgconfig, openssl, libsigcxx }:

let
  version = "0.12.9";
in
stdenv.mkDerivation {
  name = "libtorrent-${version}";

  src = fetchurl {
    url = "http://libtorrent.rakshasa.no/downloads/libtorrent-${version}.tar.gz";
    sha256 = "25dc9e8dd45d070f447e599bef08ef0ca421bac6e7f55e608dcd19360594af64";
  };

  buildInputs = [ pkgconfig openssl libsigcxx ];

  meta = {
    homepage = "http://libtorrent.rakshasa.no/";
    description = "A BitTorrent library written in C++ for *nix, with a focus on high performance and good code";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
