{stdenv, fetchurl, ncurses}:

assert ncurses != null;

stdenv.mkDerivation {
  name = "texinfo-4.6";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.gnu.org/gnu/texinfo/texinfo-4.6.tar.gz;
    md5 = "5730c8c0c7484494cca7a7e2d7459c64";
  };
  inherit ncurses;
}
