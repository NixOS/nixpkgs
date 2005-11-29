{stdenv, fetchurl, gcc40arm, kernelHeadersArm, binutilsArm}:

stdenv.mkDerivation {
  builder = ./builder.sh;
  name = "uClibc-0.9.28";
  src = fetchurl {
    url = http://www.uclibc.org/downloads/uClibc-0.9.28.tar.bz2;
    md5 = "1ada58d919a82561061e4741fb6abd29";
  };
  config = ./config;
  inherit kernelHeadersArm;
  buildInputs = [gcc40arm binutilsArm];
  makeFlags="CROSS=arm-linux-";
}
