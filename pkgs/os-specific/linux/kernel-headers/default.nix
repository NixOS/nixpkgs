{stdenv, fetchurl}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "linux-headers-2.4.25-i386";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/linux-2.4.25.tar.bz2;
    md5 = "5fc8e9f43fa44ac29ddf9a9980af57d8";
  };
}
