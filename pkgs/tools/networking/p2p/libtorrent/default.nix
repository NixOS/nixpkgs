{ stdenv, fetchurl, pkgconfig, openssl, libsigcxx }:

let
  version = "0.13.3";
in
stdenv.mkDerivation {
  name = "libtorrent-${version}";

  src = fetchurl {
    url = "http://libtorrent.rakshasa.no/downloads/libtorrent-${version}.tar.gz";
    sha256 = "0xsnyd1hnfvfq67y5s0ddhj2lhxmfms4djblaa0d1y5phdkpsc9l";
  };

  buildInputs = [ pkgconfig openssl libsigcxx ];

  meta = {
    homepage = "http://libtorrent.rakshasa.no/";
    description = "A BitTorrent library written in C++ for *nix, with a focus on high performance and good code";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
