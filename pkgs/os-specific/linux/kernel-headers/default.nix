{stdenv, fetchurl}:

assert stdenv.system == "i686-linux";

derivation {
  name = "linux-headers-2.4.25-i386";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nl.kernel.org/pub/linux/kernel/v2.4/linux-2.4.25.tar.bz2;
    md5 = "5fc8e9f43fa44ac29ddf9a9980af57d8";
  };
  inherit stdenv;
}
