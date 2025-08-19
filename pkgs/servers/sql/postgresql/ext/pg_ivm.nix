{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_ivm";
  version = "1.11";

  src = fetchFromGitHub {
    owner = "sraoss";
    repo = "pg_ivm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fPtDwP+IZ/RQOriRklSvpUnJ8qEwJaxIrcfnAReRQeQ=";
  };

  meta = {
    description = "Materialized views with IVM (Incremental View Maintenance) for PostgreSQL";
    homepage = "https://github.com/sraoss/pg_ivm";
    changelog = "https://github.com/sraoss/pg_ivm/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ ivan ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
    broken =
      lib.versionOlder postgresql.version "13"
      ||
        # PostgreSQL 18 support issue upstream: https://github.com/sraoss/pg_ivm/issues/133
        # Note: already fixed on `main` branch.
        # Check after next package update.
        lib.warnIf (finalAttrs.version != "1.11") "Is postgresql18Packages.pg_ivm still broken?" (
          lib.versionAtLeast postgresql.version "18"
        );
  };
})
