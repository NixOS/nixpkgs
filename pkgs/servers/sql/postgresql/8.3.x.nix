{ stdenv, fetchurl, zlib, ncurses, readline }:

let version = "8.3.12"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";
  
  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "0w7h09nx8pkpzznmz4wd1zv8dg3f6jv366rr8bf3s5g6vrvxcssr";
  };

  buildInputs = [ zlib ncurses readline ];

  LC_ALL = "en_US";

  passthru = { inherit readline; };

  meta = {
    homepage = http://www.postgresql.org/;
    description = "A powerful, open source object-relational database system";
    license = "bsd";
  };
}
