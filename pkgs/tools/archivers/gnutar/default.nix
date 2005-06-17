{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnutar-1.15";
  src = fetchurl {
    url = http://ftp.gnu.org/gnu/tar/tar-1.15.tar.bz2;
    md5 = "412695e2c2ecbe2753d128f303b3ccf4";
  };
}
