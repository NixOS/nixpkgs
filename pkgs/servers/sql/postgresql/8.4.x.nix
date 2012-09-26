{ stdenv, fetchurl, zlib, ncurses, readline }:

let version = "8.4.13"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "1fccqkni64vg1pi4zzcl67bm9g2brrlzjn1vh6qlyfpsld139p90";
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
