{ stdenv, fetchurl, zlib, ncurses, readline }:

let version = "8.4.1"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";
  
  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "0z4xznaba13d00hfhzaj0xja92inc5gwp1bpk4n6l6ga782sbxc5";
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
