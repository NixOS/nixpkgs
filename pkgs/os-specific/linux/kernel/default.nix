{stdenv, fetchurl, perl, mktemp}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "linux-2.6.17.5";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.kernel.org/pub/linux/kernel/v2.6/linux-2.6.17.5.tar.bz2;
    md5 = "7db2d258700c135bf490c4ea63edafe3";
  };
  config = ./config-2.6.17.1;
  inherit perl;
  buildInputs = [perl mktemp];
  arch="i386";
}
