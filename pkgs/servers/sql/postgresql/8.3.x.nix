{ stdenv, fetchurl, zlib, ncurses, readline }:

let version = "8.3.8"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";
  
  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "09b0q8fd32hiawiwp0512l25vmhkn6fl3dzrk4g9nwpwcdj5d67s";
  };

  buildInputs = [zlib ncurses readline];

  LC_ALL = "en_US";

  passthru = { inherit readline; };

  meta = {
    homepage = http://www.postgresql.org/;
    description = "A powerful, open source object-relational database system";
    license = "bsd";
  };
}
