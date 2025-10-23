{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_partman";
  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "pgpartman";
    repo = "pg_partman";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Lib7UY06qjv95ndwx3sjPBcL5MtsLNx8IVOpZ1CgDG8=";
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
