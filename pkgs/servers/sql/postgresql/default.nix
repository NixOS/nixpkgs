{stdenv, fetchurl, zlib, ncurses, readline}:

assert zlib != null;
assert ncurses != null;
assert readline != null;

stdenv.mkDerivation {
  name = "postgresql-8.0.6";
  builder = ./builder.sh;

  src = fetchurl {
    url = ftp://ftp2.nl.postgresql.org/mirror/postgresql/source/v8.0.6/postgresql-8.0.6.tar.bz2;
    md5 = "f3b27b8171267f9a87592f931c09f0ee";
  };

  inherit readline;
  buildInputs = [zlib ncurses readline];
}
