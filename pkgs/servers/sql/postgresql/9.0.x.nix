{ stdenv, fetchurl, zlib, readline }:

let version = "9.0.15"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "a45acd27d546e425911ecd371247066be5dafd96304e50e0708c84b918c28f9d";
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
