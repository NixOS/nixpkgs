{stdenv, fetchurl, perl, mktemp}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "linux-2.6.17.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/os/Linux/system/kernel/v2.6/linux-2.6.17.3.tar.bz2;
    md5 = "14bcbbbb4206ff8ec863f9f3aa21293d";
  };
  config = ./config-2.6.17.1;
  inherit perl;
  buildInputs = [perl mktemp];
  arch="i386";
}
