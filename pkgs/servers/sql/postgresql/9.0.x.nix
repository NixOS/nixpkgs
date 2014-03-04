{ stdenv, fetchurl, zlib, readline, less }:

let version = "9.0.16"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "900f6ab00fc36c94b17430e7cb22499708025da1e34d7a70aefaf9a875f0fabf";
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
    maintainers = [ stdenv.lib.maintainers.ocharles ];
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
