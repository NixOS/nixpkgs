{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_cron";
  version = "1.6.7";

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = "pg_cron";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oQjaQeIEMbg5pipY8tT4I7bNdyDOwcr/ZJikqgcEZOs=";
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
