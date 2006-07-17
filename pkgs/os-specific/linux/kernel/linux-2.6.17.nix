{stdenv, fetchurl, perl, mktemp}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "linux-2.6.17.6";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.kernel.org/pub/linux/kernel/v2.6/linux-2.6.17.6.tar.bz2;
    md5 = "5013fbe6049e32675187c203aef92218";
  };
  config = ./config-2.6.17.1;
  inherit perl;
  buildInputs = [perl mktemp];
  arch="i386";
}
