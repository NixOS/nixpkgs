{stdenv, fetchurl, patch, perl, m4}:

assert patch != null && perl != null && m4 != null;

stdenv.mkDerivation {
  name = "uml-2.4.22-3";
  builder = ./builder.sh;
  linuxSrc = fetchurl {
    url = ftp://ftp.nl.kernel.org/pub/linux/kernel/v2.4/linux-2.4.22.tar.bz2;
    md5 = "75dc85149b06ac9432106b8941eb9f7b";
  };
  umlSrc = fetchurl {
    url = http://uml-pub.ists.dartmouth.edu/uml/uml-patch-2.4.22-3.bz2;
    md5 = "1ffa698fed37d14c6750ec841b7d9858";
  };
  config = ./config;
  inherit patch perl m4;
}
