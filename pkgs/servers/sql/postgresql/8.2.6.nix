args: with args;

stdenv.mkDerivation rec {
  name = "postgresql-" + version;
  LC_ALL = "en_US";

  src = fetchurl {
    url = "ftp://ftp.de.postgresql.org/mirror/postgresql/source/v${version}/${name}.tar.bz2";
    sha256="056ixbsfmdwhniryc0mr1kl66jywkqqhqvjdi7i3v4qzh9z34hgf";
  };

  passthru = { inherit readline; };
  buildInputs = [zlib ncurses readline];
}
