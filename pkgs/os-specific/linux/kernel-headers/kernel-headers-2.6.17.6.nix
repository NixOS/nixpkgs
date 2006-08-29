{stdenv, fetchurl}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "linux-headers-2.6.17.6";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nl.kernel.org/pub/linux/kernel/v2.6/linux-2.6.17.6.tar.bz2;
    md5 = "5013fbe6049e32675187c203aef92218";
  };
}
