{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gawk-3.1.5";
  src = fetchurl {
    url = ftp://ftp.gnu.org/gnu/gawk/gawk-3.1.5.tar.bz2;
    md5 = "5703f72d0eea1d463f735aad8222655f";
  };
}
