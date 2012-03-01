{ stdenv, fetchurl, zlib, ncurses, readline }:

let version = "8.4.11"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";
  
  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "13ww30xv2pwd5hy1x5lsmba4jc59n6f6nz0dc29bb0k2s7qrzg2v";
  };

  buildInputs = [ zlib ncurses readline ];

  LC_ALL = "C";

  passthru = { inherit readline; };

  meta = {
    homepage = http://www.postgresql.org/;
    description = "A powerful, open source object-relational database system";
    license = "bsd";
  };
}
