{stdenv, fetchurl, readline, jdbcSupport ? true, ant ? null}:

assert jdbcSupport -> ant != null;

stdenv.mkDerivation {
  name = "postgresql-7.4.5";
  builder = ./builder.sh;

  src = fetchurl {
    url = ftp://ftp2.nl.postgresql.org/mirror/postgresql/latest/postgresql-7.4.5.tar.bz2;
    md5 = "97e750c8e69c208b75b6efedc5a36efb";
  };

  inherit jdbcSupport;
  ant = if jdbcSupport then ant else null;

  buildInputs = if jdbcSupport then [ant] else [];
}
