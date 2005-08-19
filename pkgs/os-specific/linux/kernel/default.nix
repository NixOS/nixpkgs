{stdenv, fetchurl, perl}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "linux-2.6.11.12";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/os/Linux/system/kernel/v2.6/linux-2.6.11.12.tar.bz2;
    md5 = "7e3b6e630bb05c1a8c1ba46e010dbe44";
  };
  config = ./config;
  inherit perl;
  buildInputs = [perl];
  arch=i386
}
