{ stdenv, fetchurl, zlib, readline }:

let version = "9.0.19"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "1h45jdbzdcvprdsi9gija81s3ny46h3faf9f007gza4vm6y15bak";
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
    license = stdenv.lib.licenses.postgresql;
    maintainers = [ stdenv.lib.maintainers.ocharles ];
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
