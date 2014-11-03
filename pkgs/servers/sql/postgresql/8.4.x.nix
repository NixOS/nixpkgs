{ stdenv, fetchurl, zlib, ncurses, readline }:

let version = "8.4.22"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "09iqr9sldiq7jz1rdnywp2wv36lxy5m8kch3vpchd1s4fz75c7aw";
  };

  buildInputs = [ zlib ncurses readline ];

  LC_ALL = "C";

  patches = [ ./less-is-more.patch ];

  passthru = { inherit readline; };

  meta = {
    homepage = http://www.postgresql.org/;
    description = "A powerful, open source object-relational database system";
    license = stdenv.lib.licenses.postgresql;
    maintainers = [ stdenv.lib.maintainers.ocharles ];
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
