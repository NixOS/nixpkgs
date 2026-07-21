{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_ivm";
  version = "1.15";

  src = fetchFromGitHub {
    owner = "sraoss";
    repo = "pg_ivm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8JQ7r/e5FRAWsshTcTmPnVnbwjXkshP4yaulYS7Zse4=";
  };

  meta = {
    description = "Materialized views with IVM (Incremental View Maintenance) for PostgreSQL";
    homepage = "https://github.com/sraoss/pg_ivm";
    changelog = "https://github.com/sraoss/pg_ivm/releases/tag/v${finalAttrs.version}";
    maintainers = [ ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
})
