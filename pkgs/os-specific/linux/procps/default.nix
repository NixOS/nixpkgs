{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "procps-3.2.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://procps.sourceforge.net/procps-3.2.4.tar.gz;
    md5 = "1bec6740b385b3f73800827437f14f85";
  };
  patches = [./makefile.patch];
  buildInputs = [ncurses];
  inherit ncurses;
}
