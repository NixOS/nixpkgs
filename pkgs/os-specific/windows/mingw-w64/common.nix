{ fetchurl }:

rec {
  version = "4.0.6";
  name = "mingw-w64-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/mingw-w64/mingw-w64-v${version}.tar.bz2";
    sha256 = "0p01vm5kx1ixc08402z94g1alip4vx66gjpvyi9maqyqn2a76h0c";
  };
}
