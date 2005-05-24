{stdenv, fetchurl, zlib, ncurses, readline, jdbcSupport ? true, ant ? null}:

assert zlib != null;
assert ncurses != null;
assert readline != null;
assert jdbcSupport -> ant != null;

stdenv.mkDerivation {
  name = "postgresql-8.0.3";
  builder = ./builder.sh;

  src = fetchurl {
    url = ftp://ftp2.nl.postgresql.org/mirror/postgresql/source/v8.0.3/postgresql-8.0.3.tar.bz2;
    md5 = "c0914a133ce6c1e0f1d8b93982d6e881";
  };

  inherit readline jdbcSupport;
  ant = if jdbcSupport then ant else null;

  buildInputs =
      [zlib ncurses readline (if jdbcSupport then [ant] else [])];
}
