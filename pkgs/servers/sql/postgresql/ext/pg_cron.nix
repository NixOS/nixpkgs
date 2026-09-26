{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_cron";
  version = "1.6.8";

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = "pg_cron";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i5bgIFBjpb2KVUk9eABz7CpP+AwlgKAPQI0vNPd7Eb8=";
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
