{ stdenv, fetchurl, zlib, readline, libossp_uuid, openssl }:

with stdenv.lib;

let version = "9.4.2"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "04adpfg2f7ip96rh3jjygx5cpgasrrp1dl2wswjivfk5q68s3zc1";
  };

  buildInputs = [ zlib readline openssl ]
                ++ optionals (!stdenv.isDarwin) [ libossp_uuid ];

  enableParallelBuilding = true;

  makeFlags = [ "world" ];

  configureFlags = [ "--with-openssl" ]
                   ++ optional (!stdenv.isDarwin) "--with-ossp-uuid";

  patches = [ ./disable-resolve_symlinks-94.patch ./less-is-more.patch ];

  installTargets = [ "install-world" ];

  LC_ALL = "C";

  passthru = {
    inherit readline;
    psqlSchema = "9.4";
  };

  meta = {
    homepage = http://www.postgresql.org/ ;
    description = "A powerful, open source object-relational database system";
    license = stdenv.lib.licenses.postgresql;
    maintainers = with stdenv.lib.maintainers; [ aristid ocharles ];
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
