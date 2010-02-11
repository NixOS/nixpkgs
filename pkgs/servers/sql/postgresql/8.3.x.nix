{ stdenv, fetchurl, zlib, ncurses, readline }:

let version = "8.3.9"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";
  
  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "08z6p3hha0v5841kzz5mhz1gsyvriijssx5p8bah8cvw4i00xcaw";
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
