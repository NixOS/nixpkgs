{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "zip-2.32";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.info-zip.org/pub/infozip/src/zip232.tgz;
    md5 = "8a4da4460386e324debe97f3b7fe4d96";
  };
}
