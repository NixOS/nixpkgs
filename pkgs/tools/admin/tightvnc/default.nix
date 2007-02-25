{stdenv, fetchurl, x11, zlib, libjpeg, imake, gccmakedep, libXmu, libXaw, libXpm, libXp}:

stdenv.mkDerivation {
  name = "tightvnc-1.3.8";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://belnet.dl.sourceforge.net/sourceforge/vnc-tight/tightvnc-1.3.8_unixsrc.tar.bz2;
    sha256 = "0y0ii1w21zcvm3kwxbjcxyqjwr5krmc32jawg8mfqgw4qv2y2xnd";
  };
  buildInputs = [x11 zlib libjpeg imake gccmakedep libXmu libXaw libXpm libXp];
}
