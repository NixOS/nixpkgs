{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "hwdata-0.172";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/os/Linux/distr/debian/pool/main/h/hwdata/hwdata_0.172.orig.tar.gz;
    md5 = "1c6b7f4dfe489f881702176c5f8e5a2e";
  };
}
