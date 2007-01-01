{stdenv, fetchurl, gccCross ? null, binutilsCross ? null}:

stdenv.mkDerivation {
  name = "busybox-1.3.1";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://busybox.net/downloads/busybox-1.3.1.tar.bz2;
    md5 = "571531cfa83726947ccb566de017ad4f";
  };

  # inherit gccCross;
  # buildinputs = [binutilsCross];
  # fixme, need a decent config for MIPS or so
  config = ./x86-config-1.2;
}
