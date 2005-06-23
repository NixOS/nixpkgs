{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "mingetty-1.07";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/os/Linux/distr/debian/pool/main/m/mingetty/mingetty_1.07.orig.tar.gz;
    md5 = "491dedf1ceff0e0f5f7bb9f55bf5213e";
  };
  patches = [./makefile.patch];
}
