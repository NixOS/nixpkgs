{stdenv, fetchurl, cross}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "linux-headers-2.6.13.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.13.4.tar.bz2;
    md5 = "94768d7eef90a9d8174639b2a7d3f58d";
  };
  inherit cross;
}
