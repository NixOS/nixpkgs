{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "bzip2-1.0.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://sources.redhat.com/pub/bzip2/v102/bzip2-1.0.2.tar.gz;
    md5 = "ee76864958d568677f03db8afad92beb";
  };
}
