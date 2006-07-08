{stdenv, fetchurl, gccCross, binutilsCross}:

stdenv.mkDerivation {
  name = "busybox-1.2.0";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://busybox.net/downloads/busybox-1.2.0.tar.bz2;
    md5 = "0a3e5d47adc4debda22726295f40a6f2";
  };

  inherit gccCross;
  buildinputs = [binutilsCross];
  # fixme, need a decent config for MIPS or so
  config = ./config-1.2;

}
