{stdenv, fetchurl, bison, flex}:

stdenv.mkDerivation {
  name = "modutils-2.4.25";
  src = fetchurl {
    url = ftp://ftp.nl.kernel.org/pub/linux/utils/kernel/modutils/v2.4/modutils-2.4.25.tar.bz2;
    md5 = "2c0cca3ef6330a187c6ef4fe41ecaa4d";
  };
  buildInputs = [bison flex];
}
