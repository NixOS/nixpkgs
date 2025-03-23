{
  fetchFromGitHub,
  freetds,
  lib,
  postgresql,
  postgresqlBuildExtension,
  stdenv,
  unstableGitUpdater,
}:

postgresqlBuildExtension rec {
  pname = "tds_fdw";
  version = "2.0.4";

  buildInputs = [ freetds ];

  src = fetchFromGitHub {
    owner = "tds-fdw";
    repo = "tds_fdw";
    tag = "v${version}";
    hash = "sha256-ruelOHueaHx1royLPvDM8Abd1rQD62R4KXgtHY9qqTw=";
  };

  meta = {
    description = "PostgreSQL foreign data wrapper to connect to TDS databases (Sybase and Microsoft SQL Server)";
    homepage = "https://github.com/tds-fdw/tds_fdw";
    changelog = "https://github.com/tds-fdw/tds_fdw/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ steve-chavez ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
}
