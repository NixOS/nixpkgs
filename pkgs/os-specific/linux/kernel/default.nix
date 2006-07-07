{stdenv, fetchurl, perl, mktemp}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "linux-2.6.17.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/os/Linux/system/kernel/v2.6/linux-2.6.17.4.tar.bz2;
    md5 = "d33826d07134d33e526f3e828af24287";
  };
  config = ./config-2.6.17.1;
  inherit perl;
  buildInputs = [perl mktemp];
  arch="i386";
}
