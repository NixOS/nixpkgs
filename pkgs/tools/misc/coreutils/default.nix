{stdenv, fetchurl}:

derivation {
  name = "coreutils-5.0";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/coreutils/coreutils-5.0.tar.bz2;
    md5 = "94e5558ee2a65723d4840bfde2d323f0";
  };
  inherit stdenv;
}
