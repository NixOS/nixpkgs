{stdenv, fetchurl, ps, ncurses, zlib ? null, perl}:

# Note: zlib is not required; MySQL can use an internal zlib.

stdenv.mkDerivation {
  name = "mysql-4.1.9";
#  builder = ./builder.sh;

  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/mysql-4.1.9.tar.gz;
    md5 = "7bc44befe155d619c4e4705f68874278";
  };

  buildInputs = [ps ncurses zlib perl];
}
