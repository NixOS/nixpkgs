{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "zip-2.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.info-zip.org/pub/infozip/src/zip23.tar.gz;
    md5 = "5206a99541f3b0ab90f1baa167392c4f";
  };
}
