{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cabextract-1.1";
  src = fetchurl {
    url = http://www.kyz.uklinux.net/downloads/cabextract-1.1.tar.gz;
    md5 = "f4b729c0be7d288660f4fc167de199a1";
  };
}
