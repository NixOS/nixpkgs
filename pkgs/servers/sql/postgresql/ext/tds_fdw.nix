{ lib, stdenv, fetchFromGitHub, postgresql, freetds, unstableGitUpdater }:

stdenv.mkDerivation rec {
  pname = "tds_fdw";
  version = "2.0.4";

  buildInputs = [ postgresql freetds ];

  src = fetchFromGitHub {
    owner  = "tds-fdw";
    repo   = "tds_fdw";
    rev    = "v${version}";
    hash   = "sha256-ruelOHueaHx1royLPvDM8Abd1rQD62R4KXgtHY9qqTw=";
  };

  installPhase = ''
    version="$(sed -En "s,^default_version *= *'([^']*)'.*,\1,p" tds_fdw.control)"
    install -D tds_fdw${postgresql.dlSuffix} -t $out/lib
    install -D sql/tds_fdw.sql    "$out/share/postgresql/extension/tds_fdw--$version.sql"
    install -D tds_fdw.control -t $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "PostgreSQL foreign data wrapper to connect to TDS databases (Sybase and Microsoft SQL Server)";
    homepage    = "https://github.com/tds-fdw/tds_fdw";
    changelog = "https://github.com/tds-fdw/tds_fdw/releases/tag/v${version}";
    maintainers = [ maintainers.steve-chavez ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
  };
}
