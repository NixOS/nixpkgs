{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "coreutils-6.4";
  src = fetchurl {
    url = http://ftp.gnu.org/pub/gnu/coreutils/coreutils-6.4.tar.bz2;
    md5 = "a3806c709c7f063b80612be846a9d88c";
  };
}
