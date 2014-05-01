{ stdenv, fetchurl, zlib, ncurses, readline }:

let version = "8.4.21"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "388f67e59f2a16c27e84f50656f5d755adf3d0a883138366d091aa0c727c1e2c";
  };

  buildInputs = [ zlib ncurses readline ];

  LC_ALL = "C";

  patches = [ ./less-is-more.patch ];

  passthru = { inherit readline; };

  meta = {
    homepage = http://www.postgresql.org/;
    description = "A powerful, open source object-relational database system";
    license = "bsd";
    maintainers = [ stdenv.lib.maintainers.ocharles ];
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
