{ stdenv, fetchurl, zlib, readline }:

let version = "9.0.16"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "900f6ab00fc36c94b17430e7cb22499708025da1e34d7a70aefaf9a875f0fabf";
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
