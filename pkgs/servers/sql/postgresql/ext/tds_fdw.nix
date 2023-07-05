{ lib, stdenv, fetchFromGitHub, postgresql, freetds }:

stdenv.mkDerivation rec {
  pname = "tds_fdw";
  # Move to stable version when it's released.
  version = "unstable-2021-12-14";

  buildInputs = [ postgresql freetds ];

  src = fetchFromGitHub {
    owner  = "tds-fdw";
    repo   =  pname;
    rev    = "1611a2805f85d84f463ae50c4e0765cb9bed72dc";
    sha256 = "sha256-SYHo/o9fJjB1yzN4vLJB0RrF3HEJ4MzmEO44/Jih/20=";
  };

  installPhase = ''
    version="$(sed -En "s,^default_version *= *'([^']*)'.*,\1,p" tds_fdw.control)"
    install -D tds_fdw.so      -t $out/lib
    install -D sql/tds_fdw.sql    "$out/share/postgresql/extension/tds_fdw--$version.sql"
    install -D tds_fdw.control -t $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "A PostgreSQL foreign data wrapper to connect to TDS databases (Sybase and Microsoft SQL Server)";
    homepage    = "https://github.com/tds-fdw/tds_fdw";
    maintainers = [ maintainers.steve-chavez ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
  };
}
