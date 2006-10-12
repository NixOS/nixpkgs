{stdenv, fetchurl, gccCross, binutilsCross}:

stdenv.mkDerivation {
  name = "busybox-1.1.3";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/busybox-1.1.3.tar.bz2;
    md5 = "19a0b475169335f17e421cf644616fe7";
  };

  inherit gccCross;
  buildinputs = [binutilsCross];
  config = ./mips-config-1.1;

}
