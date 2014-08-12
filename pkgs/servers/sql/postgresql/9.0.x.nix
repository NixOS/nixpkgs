{ stdenv, fetchurl, zlib, readline }:

let version = "9.0.18"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "7c8a07d0ab78fe39522c6bb268a7b357f456d9d4796f57d7b43a004e4a9d3003";
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
