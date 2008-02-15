{stdenv, fetchurl, zlib, ncurses, readline}:

assert zlib != null;
assert ncurses != null;
assert readline != null;

stdenv.mkDerivation {
  name = "postgresql-8.3.0";

  src = fetchurl {
    url = http://ftp2.nl.postgresql.org/source/v8.3.0/postgresql-8.3.0.tar.bz2;
    sha256 = "19kf0q45d5zd1rxffin0iblizckk8cp6fpgb52sipqkpnmm6sdc5";
  };

  inherit readline;
  
  buildInputs = [zlib ncurses readline];

  LANG = "en_US"; # is this needed anymore?

  meta = {
    description = "The world's most advanced open source database";
    homepage = http://www.postgresql.org/;
  };
}
