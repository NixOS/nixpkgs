{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cpio-2.6";
  src = fetchurl {
    url = ftp://ftp.gnu.org/pub/gnu/cpio/cpio-2.6.tar.bz2;
    md5 = "25e0e8725bc60ed3460c9cde92752674";
  };
}
