args: with args;

stdenv.mkDerivation rec {
  name = "postgresql-" + version;
  LC_ALL = "en_US";

  src = fetchurl {
    url = "ftp://ftp.de.postgresql.org/mirror/postgresql/source/v${version}/${name}.tar.bz2";
    sha256="19kf0q45d5zd1rxffin0iblizckk8cp6fpgb52sipqkpnmm6sdc5";
  };

  passthru = { inherit readline; };
  buildInputs = [zlib ncurses readline];
}
