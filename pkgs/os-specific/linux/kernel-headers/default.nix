{stdenv, fetchurl}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "linux-headers-2.6.10-i386";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/linux-2.6.10.tar.bz2;
    md5 = "cffcd2919d9c8ef793ce1ac07a440eda";
  };
}
