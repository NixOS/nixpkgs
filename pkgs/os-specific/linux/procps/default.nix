{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "procps-2.0.11";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://surriel.com/procps/procps-2.0.11.tar.bz2;
    md5 = "8b9464631ebb02f1c2bcda16fb81d62f";
  };
  patches = [./makefile.patch];
  buildInputs = [ncurses];
  inherit ncurses;
  # Needed for `sort -n +2' invocation in the Makefile.
  _POSIX2_VERSION = "199209";
}
