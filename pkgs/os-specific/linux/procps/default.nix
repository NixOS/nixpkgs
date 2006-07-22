{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "procps-3.2.7";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://procps.sourceforge.net/procps-3.2.7.tar.gz;
    md5 = "f490bca772b16472962c7b9f23b1e97d";
  };
  patches = [./makefile.patch ./procps-build.patch];
  buildInputs = [ncurses];
}
