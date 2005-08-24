{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "hwdata-0.159";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/os/Linux/distr/debian/pool/main/h/hwdata/hwdata_0.159.orig.tar.gz;
    md5 = "5756e42e70955b15dc62cfcdbaa1c885";
  };
}
