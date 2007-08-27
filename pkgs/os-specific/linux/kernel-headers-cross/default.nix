{stdenv, fetchurl, cross}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "linux-headers-2.6.14.5";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://kernel/linux/kernel/v2.6/linux-2.6.14.5.tar.bz2;
    md5 = "9f057e3bd31c50dc48553def01bc8037";
  };
  inherit cross;
}
