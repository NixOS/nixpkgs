{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pgvector";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "pgvector";
    repo = "pgvector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JsZV+I4eRMypXTjGmjCtMBXDVpqTIPHQa28ogXncE/Q=";
  };

  meta = {
    # PostgreSQL 18 support issue upstream: https://github.com/pgvector/pgvector/issues/869
    # Note: already fixed on `master` branch.
    # Check after next package update.
    broken = lib.warnIf (
      finalAttrs.version != "0.8.0"
    ) "Is postgresql18Packages.pgvector still broken?" (lib.versionAtLeast postgresql.version "18");
    description = "Open-source vector similarity search for PostgreSQL";
    homepage = "https://github.com/pgvector/pgvector";
    changelog = "https://github.com/pgvector/pgvector/raw/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = [ ];
  };
})
