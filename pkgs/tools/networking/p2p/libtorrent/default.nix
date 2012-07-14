{ stdenv, fetchurl, pkgconfig, openssl, libsigcxx }:

let
  version = "0.13.2";
in
stdenv.mkDerivation {
  name = "libtorrent-${version}";

  src = fetchurl {
    url = "http://libtorrent.rakshasa.no/downloads/libtorrent-${version}.tar.gz";
    sha256 = "ed2f2dea16c29cac63fa2724f6658786d955f975861fa6811bcf1597ff8a5e4f";
  };

  buildInputs = [ pkgconfig openssl libsigcxx ];

  meta = {
    homepage = "http://libtorrent.rakshasa.no/";
    description = "A BitTorrent library written in C++ for *nix, with a focus on high performance and good code";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
