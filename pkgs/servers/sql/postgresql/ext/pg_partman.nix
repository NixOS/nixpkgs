{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_partman";
  version = "5.5.1";

  src = fetchFromGitHub {
    owner = "pgpartman";
    repo = "pg_partman";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9ZuemWP4FdvcUxDLbWI9arOdqmY871XWeaI3aHS9CFM=";
  };

  meta = {
    description = "Partition management extension for PostgreSQL";
    homepage = "https://github.com/pgpartman/pg_partman";
    changelog = "https://github.com/pgpartman/pg_partman/blob/v${finalAttrs.version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ ggpeti ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
})
