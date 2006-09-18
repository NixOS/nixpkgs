{stdenv, fetchurl, perl, mktemp}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "linux-2.6.17.13";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.nl.kernel.org/pub/linux/kernel/v2.6/linux-2.6.17.13.tar.bz2;
    md5 = "834885b3ad9988b966570bee92459572";
  };
  config = ./config-2.6.17.1;
  inherit perl;
  buildInputs = [perl mktemp];
  arch="i386";
}
