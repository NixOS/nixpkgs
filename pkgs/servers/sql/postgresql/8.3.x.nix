{ stdenv, fetchurl, zlib, ncurses, readline }:

let version = "8.3.23"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "1n8qj1bvyx83jsn2x2l8xzk53c014gkz8hwvswvnzcdyvlbnd90p";
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
