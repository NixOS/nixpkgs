{ stdenv, fetchurl, zlib, ncurses, readline }:

let version = "8.4.20"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "e84e46083a6accd2bf37f0bd7253415649afcafc49f2564bc8481c10ed90d7c1";
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
