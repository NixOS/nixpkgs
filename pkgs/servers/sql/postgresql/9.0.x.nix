{ stdenv, fetchurl, zlib, readline }:

let version = "9.0.17"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "d2f6d09cf941e7cbab6ee399f14080dbe822af58fda9fd132efb05c2b7d160ad";
  };

  buildInputs = [ zlib readline ];

  LC_ALL = "C";

  patches = [ ./less-is-more.patch ];

  passthru = {
    inherit readline;
    psqlSchema = "9.0";
  };

  meta = {
    homepage = http://www.postgresql.org/;
    description = "A powerful, open source object-relational database system";
    license = "bsd";
    maintainers = [ stdenv.lib.maintainers.ocharles ];
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
