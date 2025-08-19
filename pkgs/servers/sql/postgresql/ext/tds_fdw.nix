{
  fetchFromGitHub,
  freetds,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "tds_fdw";
  version = "2.0.4";

  buildInputs = [ freetds ];

  src = fetchFromGitHub {
    owner = "tds-fdw";
    repo = "tds_fdw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ruelOHueaHx1royLPvDM8Abd1rQD62R4KXgtHY9qqTw=";
  };

  meta = {
    # PostgreSQL 18 support issue upstream: https://github.com/tds-fdw/tds_fdw/issues/384
    # Check after next package update.
    broken = lib.warnIf (
      finalAttrs.version != "2.0.4"
    ) "Is postgresql18Packages.tds_fdw still broken?" (lib.versionAtLeast postgresql.version "18");
    description = "PostgreSQL foreign data wrapper to connect to TDS databases (Sybase and Microsoft SQL Server)";
    homepage = "https://github.com/tds-fdw/tds_fdw";
    changelog = "https://github.com/tds-fdw/tds_fdw/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ steve-chavez ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
})
