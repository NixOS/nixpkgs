{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "gnum4-1.4.3";
  src = fetchurl {
    url = http://ftp.gnu.org/gnu/m4/m4-1.4.3.tar.bz2;
    md5 = "1f7d7eba70a0525c44c2edc3998925c7";
  };
}
