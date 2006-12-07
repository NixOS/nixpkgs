{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cabextract-1.2";
  src = fetchurl {
    url = http://www.kyz.uklinux.net/downloads/cabextract-1.2.tar.gz;
    md5 = "dc421a690648b503265c82ade84e143e";
  };
}
