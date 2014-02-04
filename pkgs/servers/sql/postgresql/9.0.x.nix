{ stdenv, fetchurl, zlib, readline, less }:

let version = "9.0.15"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "a45acd27d546e425911ecd371247066be5dafd96304e50e0708c84b918c28f9d";
  };

  buildInputs = [ zlib readline ];

  prePatch = ''
    sed -e 's|#define DEFAULT_PAGER.*|#define DEFAULT_PAGER "${less}/bin/less"|' \
        -i src/bin/psql/print.h
  '';

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
