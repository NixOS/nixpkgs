{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "ethtool-3.2";

  src = fetchurl {
    url = mirror://kernel/software/network/ethtool/ethtool-3.2.tar.xz;
    sha256 = "0g9ldaba3vwlsmf490j33y3fgsmpfzxlzzblwashl448f8lcfap7";
  };

}
