{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_ivm";
  version = "1.12";

  src = fetchFromGitHub {
    owner = "sraoss";
    repo = "pg_ivm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UeRcxoUkpPw4EcQXKUxHamjczOaE59d00kSrYsijnH8=";
  };

  meta = {
    description = "Materialized views with IVM (Incremental View Maintenance) for PostgreSQL";
    homepage = "https://github.com/sraoss/pg_ivm";
    changelog = "https://github.com/sraoss/pg_ivm/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ ivan ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
})
