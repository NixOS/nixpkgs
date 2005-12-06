{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "coreutils-5.93";
  src = fetchurl {
    url = http://ftp.gnu.org/pub/gnu/coreutils/coreutils-5.93.tar.bz2;
    md5 = "955d8abfd3dd8af2ca3af51480f1f9af";
  };
}
