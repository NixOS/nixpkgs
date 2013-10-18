{ stdenv, fetchurl, zlib, ncurses, readline }:

let version = "8.4.18"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "c08e5e93dac9d484019a07ff91db9f224350b90ef4be1543e33282cc20daf872";
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
