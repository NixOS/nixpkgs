{stdenv, fetchurl}: derivation {
  name = "zip-2.3";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.info-zip.org/pub/infozip/src/zip23.tar.gz;
    md5 = "5206a99541f3b0ab90f1baa167392c4f";
  };
  stdenv = stdenv;
}
