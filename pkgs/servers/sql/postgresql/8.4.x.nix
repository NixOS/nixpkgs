{ stdenv, fetchurl, zlib, ncurses, readline }:

let version = "8.4.2"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";
  
  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "1wk9k1nsz304c8mxrx4iix1ss38fpp13by46x5v5s6cn0g4wbcxd";
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
