{ stdenv, fetchurl, zlib, readline }:

let version = "9.0.11"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "0b3vw1a1x658famvgsfi1dladrbkc5j3h1ibaasgx9ffqn6xrp56";
  };

  buildInputs = [ zlib readline ];

  LC_ALL = "C";

  passthru = {
    inherit readline;
    psqlSchema = "9.0";
  };

  meta = {
    homepage = http://www.postgresql.org/;
    description = "A powerful, open source object-relational database system";
    license = "bsd";
  };
}
