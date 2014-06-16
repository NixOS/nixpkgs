{ stdenv, fetchurl, pkgconfig, openssl, libsigcxx, zlib }:

let
  version = "0.13.4";
in
stdenv.mkDerivation {
  name = "libtorrent-${version}";

  src = fetchurl {
    url = "http://libtorrent.rakshasa.no/downloads/libtorrent-${version}.tar.gz";
    sha256 = "0ma910br5vxrfpm4f4w4942lpmhwvqjnnf9h8vpf52fw35qhjkkh";
  };

  buildInputs = [ pkgconfig openssl libsigcxx zlib ];

  meta = {
    homepage = "http://libtorrent.rakshasa.no/";
    description = "A BitTorrent library written in C++ for *nix, with a focus on high performance and good code";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
