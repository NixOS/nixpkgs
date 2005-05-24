{stdenv, fetchurl, zlib, ncurses, readline}:

assert zlib != null;
assert ncurses != null;
assert readline != null;

stdenv.mkDerivation {
  name = "postgresql-8.0.3";
  builder = ./builder.sh;

  src = fetchurl {
    url = ftp://ftp2.nl.postgresql.org/mirror/postgresql/source/v8.0.3/postgresql-8.0.3.tar.bz2;
    md5 = "c0914a133ce6c1e0f1d8b93982d6e881";
  };

  inherit readline;
  buildInputs = [zlib ncurses readline];
}
