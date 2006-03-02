{stdenv, fetchurl, gccCross, binutilsCross}:

stdenv.mkDerivation {
  name = "busybox-1.1.0";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://www.busybox.net/downloads/busybox-1.1.0.tar.bz2;
    md5 = "855e12c7c9dc90e16b014a788925e4cb";
  };

  inherit gccCross;
  buildinputs = [binutilsCross];
  config = ./config;

}
