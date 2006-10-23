{stdenv, fetchurl}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "linux-headers-2.6.18.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nl.kernel.org/pub/linux/kernel/v2.6/linux-2.6.18.1.tar.bz2;
    md5 = "38f00633b02f07819d17bcd87d03eb3a";
  };
}
