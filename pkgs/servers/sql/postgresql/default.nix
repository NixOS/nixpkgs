{stdenv, fetchurl, zlib, ncurses, readline, jdbcSupport ? true, ant ? null}:

assert zlib != null;
assert ncurses != null;
assert readline != null;
assert jdbcSupport -> ant != null;

stdenv.mkDerivation {
  name = "postgresql-7.4.5";
  builder = ./builder.sh;

  src = fetchurl {
    url = ftp://ftp2.nl.postgresql.org/mirror/postgresql/src/7.4.5/postgresql-7.4.5.tar.bz2;
    md5 = "97e750c8e69c208b75b6efedc5a36efb";
  };

  inherit readline jdbcSupport;
  ant = if jdbcSupport then ant else null;

  buildInputs =
      [zlib ncurses readline (if jdbcSupport then [ant] else [])];
}
