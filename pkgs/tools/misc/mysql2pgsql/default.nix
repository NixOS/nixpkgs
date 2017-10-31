{ stdenv, fetchurl, perl }:

# The homepage says this script is mature..
stdenv.mkDerivation {
  name = "mysql2pgsql-0.0.1a";

  src = fetchurl {
    url = http://ftp.plusline.de/ftp.postgresql.org/projects/gborg/mysql2psql/devel/mysql2psql-0.0.1a.tgz;
    sha256 = "0dpbxf3kdvpihz9cisx6wi3zzd0cnifaqvjxavrbwm4k4sz1qamp";
  };

  buildInputs = [ perl ];

  installPhase = ''
    mkdir -p $out/bin
    mv {,$out/bin/}mysql2psql
  '';

  meta = {
    description = "Convert MySQL dump files to PostgreSQL-loadable files";
    homepage = http://pgfoundry.org/projects/mysql2pgsql/;
    license = stdenv.lib.licenses.bsdOriginal;
    platforms = stdenv.lib.platforms.unix;
  };
}
