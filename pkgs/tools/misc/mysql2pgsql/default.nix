{ lib, stdenv, fetchurl, perl }:

# The homepage says this script is mature..
stdenv.mkDerivation rec {
  pname = "mysql2pgsql";
  version = "0.0.1a";

  src = fetchurl {
    url = "http://ftp.plusline.de/ftp.postgresql.org/projects/gborg/mysql2psql/devel/mysql2psql-${version}.tgz";
    sha256 = "0dpbxf3kdvpihz9cisx6wi3zzd0cnifaqvjxavrbwm4k4sz1qamp";
  };

  buildInputs = [ perl ];

  installPhase = ''
    mkdir -p $out/bin
    mv {,$out/bin/}mysql2psql
  '';

  meta = {
    description = "Convert MySQL dump files to PostgreSQL-loadable files";
    homepage = "https://pgfoundry.org/projects/mysql2pgsql/";
    license = lib.licenses.bsdOriginal;
    mainProgram = "mysql2psql";
    platforms = lib.platforms.unix;
  };
}
