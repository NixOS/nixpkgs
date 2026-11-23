{
  fetchFromGitHub,
  freetds,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "tds_fdw";
  version = "2.0.5-unstable-2026-07-21";

  buildInputs = [ freetds ];

  src = fetchFromGitHub {
    owner = "tds-fdw";
    repo = "tds_fdw";
    rev = "6916ee63eca26311d7072c4977d9292b696ab049";
    hash = "sha256-9lOCHU3Gl/mOeXJaCv2psoQM9pW4UuvrfHNcXipaHbc=";
  };

  meta = {
    description = "PostgreSQL foreign data wrapper to connect to TDS databases (Sybase and Microsoft SQL Server)";
    homepage = "https://github.com/tds-fdw/tds_fdw";
    changelog = "https://github.com/tds-fdw/tds_fdw/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ steve-chavez ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
})
