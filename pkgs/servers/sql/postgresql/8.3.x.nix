{ stdenv, fetchurl, zlib, ncurses, readline }:

let version = "8.3.19"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";
  
  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "1maq1gjnd111jn45d7k58av1dm273vypvwhhsbhknqywgr5hsvwq";
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
