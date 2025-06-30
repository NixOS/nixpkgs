{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_partman";
  version = "5.2.4";

  src = fetchFromGitHub {
    owner = "pgpartman";
    repo = "pg_partman";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i/o+JZEXnJRO17kfdTw87aca28+I8pvuFZsPMA/kf+w=";
  };

  meta = {
    description = "Partition management extension for PostgreSQL";
    homepage = "https://github.com/pgpartman/pg_partman";
    changelog = "https://github.com/pgpartman/pg_partman/blob/v${finalAttrs.version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ ggpeti ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
    broken = lib.versionOlder postgresql.version "14";
  };
})
