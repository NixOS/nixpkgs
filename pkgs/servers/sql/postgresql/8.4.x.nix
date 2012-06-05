{ stdenv, fetchurl, zlib, ncurses, readline }:

let version = "8.4.12"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";
  
  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "0xqgzi6qrx4g7g8f38hp02qj8grrfnvc33kyijc2hf0qxhqb7dwr";
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
