{stdenv, fetchurl, zlib, ncurses, readline}:

assert zlib != null;
assert ncurses != null;
assert readline != null;

stdenv.mkDerivation {
  name = "postgresql-8.2.6";
  builder = ./builder.sh;

  src = fetchurl {
    url = ftp://ftp.de.postgresql.org/mirror/postgresql/source/v8.2.6/postgresql-8.2.6.tar.bz2;
    sha256="056ixbsfmdwhniryc0mr1kl66jywkqqhqvjdi7i3v4qzh9z34hgf";
  };

  inherit readline;
  buildInputs = [zlib ncurses readline];
}
