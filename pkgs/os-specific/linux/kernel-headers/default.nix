{stdenv, fetchurl}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "linux-headers-2.6.9-i386";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/os/Linux/system/kernel/v2.6/linux-2.6.9.tar.bz2;
    md5 = "e921200f074ca97184e150ef5a4af825";
  };
}
