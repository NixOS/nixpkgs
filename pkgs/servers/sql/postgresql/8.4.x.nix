{ stdenv, fetchurl, zlib, ncurses, readline }:

let version = "8.4.14"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "0fhk3mmk95p5gwmg2skqv1rfi7ylk8gw195hx8rska7fbdryfwhi";
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
