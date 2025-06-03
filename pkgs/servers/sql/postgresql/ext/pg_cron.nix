{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_cron";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = "pg_cron";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Llksil7Fk7jvJJmCpfCN0Qm2b2I4J1VOA7/ibytO+KM=";
  };

  meta = {
    description = "Run Cron jobs through PostgreSQL";
    homepage = "https://github.com/citusdata/pg_cron";
    changelog = "https://github.com/citusdata/pg_cron/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ thoughtpolice ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
})
