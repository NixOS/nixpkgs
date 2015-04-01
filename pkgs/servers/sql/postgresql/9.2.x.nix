{ stdenv, fetchurl, zlib, readline, openssl }:

let version = "9.2.10"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "1bbkinqzb3c8i0vfzcy2g7djrq0kxz63jgvzda9p0vylxazmnm1m";
  };

  buildInputs = [ zlib readline openssl ];

  enableParallelBuilding = true;

  makeFlags = [ "world" ];

  configureFlags = [ "--with-openssl" ];

  patches = [ ./disable-resolve_symlinks.patch ./less-is-more.patch ];

  installTargets = [ "install-world" ];

  LC_ALL = "C";

  passthru = {
    inherit readline;
    psqlSchema = "9.2";
  };

  meta = {
    homepage = http://www.postgresql.org/;
    description = "A powerful, open source object-relational database system";
    license = stdenv.lib.licenses.postgresql;
    maintainers = [ stdenv.lib.maintainers.ocharles ];
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
