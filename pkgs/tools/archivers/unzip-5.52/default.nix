{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "unzip-5.52";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.info-zip.org/pub/infozip/src/unzip552.tar.gz;
    md5 = "9d23919999d6eac9217d1f41472034a9";
  };
}
