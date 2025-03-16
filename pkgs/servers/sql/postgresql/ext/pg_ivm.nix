{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  stdenv,
}:

postgresqlBuildExtension rec {
  pname = "pg_ivm";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "sraoss";
    repo = "pg_ivm";
    tag = "v${version}";
    hash = "sha256-Qcie7sbXcMbQkMoFIYBfttmvlYooESdSk2DyebHKPlk=";
  };

  meta = {
    description = "Materialized views with IVM (Incremental View Maintenance) for PostgreSQL";
    homepage = "https://github.com/sraoss/pg_ivm";
    changelog = "https://github.com/sraoss/pg_ivm/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ ivan ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
    broken = lib.versionOlder postgresql.version "13";
  };
}
