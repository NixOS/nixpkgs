{stdenv, fetchurl}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "linux-headers-2.6.11.12-i386";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.11.12.tar.bz2;
    md5 = "7e3b6e630bb05c1a8c1ba46e010dbe44";
  };
}
