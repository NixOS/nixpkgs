{stdenv, fetchurl, zlib}:

stdenv.mkDerivation {
  name = "cramfsswap-1.4.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://debian/pool/main/c/cramfsswap/cramfsswap_1.4.1.tar.gz;
    sha256 = "0c6lbx1inkbcvvhh3y6fvfaq3w7d1zv7psgpjs5f3zjk1jysi9qd";
  };

  buildInputs = [zlib];

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
