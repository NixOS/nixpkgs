{
  fetchFromGitHub,
  freetds,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "tds_fdw";
  version = "2.0.5";

  buildInputs = [ freetds ];

  src = fetchFromGitHub {
    owner = "tds-fdw";
    repo = "tds_fdw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4ecdErksaZ7SyCKzvSY5sD7rrKljq7BMn+gI9Yz49r0=";
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
