{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "procps-3.2.6";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/procps-3.2.6.tar.gz;
    md5 = "7ce39ea27d7b3da0e8ad74dd41d06783";
  };
  patches = [./makefile.patch ./procps-build.patch];
  buildInputs = [ncurses];
}
