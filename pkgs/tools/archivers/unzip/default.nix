{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "unzip-5.50";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.info-zip.org/pub/infozip/src/unzip550.tar.gz;
    md5 = "798592d62e37f92571184236947122ed";
  };
}
