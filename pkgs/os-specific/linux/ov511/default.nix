{stdenv, fetchurl, kernel}:

stdenv.mkDerivation {
  name = "ov511-2.30";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://alpha.dyndns.org/ov511/download/2.xx/distros/ov511-2.30.tar.bz2;
    md5 = "9eacf9e54f2f54a59ddbf14221a53f2a";
  };
  patches = [./ov511-kernel.patch];
  inherit kernel;
}
