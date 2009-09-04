args: with args;

stdenv.mkDerivation rec {
  name = "postgresql-" + version;
  LC_ALL = "en_US";

  src = fetchurl {
    url = "ftp://ftp.nl.postgresql.org/pub/mirror/postgresql/source/v${version}/${name}.tar.bz2";
    sha256="01z00pgp2dmp02dq6hnsidzvkp19gwjby0xvfpwgvd2xljs57gw4";
  };

  passthru = { inherit readline; };
  buildInputs = [zlib ncurses readline];
}
