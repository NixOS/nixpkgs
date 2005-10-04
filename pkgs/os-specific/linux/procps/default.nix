{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "procps-3.2.5";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://procps.sourceforge.net/procps-3.2.5.tar.gz;
    md5 = "cde0e3612d1d7c68f404d46f01c44fb4";
  };
  patches = [./makefile.patch];
  buildInputs = [ncurses];
}
